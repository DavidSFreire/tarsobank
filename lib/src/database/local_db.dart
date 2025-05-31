import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tarsobank/src/database/models/user_model.dart'; 
import 'package:tarsobank/src/database/models/transaction_model.dart'; 
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    String databasePath = join(path, 'tarsobank.db');

    return await openDatabase(
      databasePath,
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cpf TEXT UNIQUE,
        phone TEXT,
        email TEXT,
        address TEXT,
        password TEXT,
        accountNumber TEXT UNIQUE,
        agency TEXT,
        balance REAL DEFAULT 0.0 -- <<---- NOVO CAMPO SALDO
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions( -- <<---- NOVA TABELA TRANSACTIONS
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        senderUserId INTEGER,     -- FK para users.id (quem envia)
        receiverAccountNumber TEXT, -- Conta de quem recebe
        amount REAL,
        timestamp TEXT,
        description TEXT,
        type TEXT, -- 'TRANSFER_SENT', 'TRANSFER_RECEIVED', 'DEPOSIT', 'WITHDRAWAL'
        FOREIGN KEY (senderUserId) REFERENCES users(id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN accountNumber TEXT UNIQUE',
        );
      } catch (e) {
        print("Coluna accountNumber já existe ou erro: $e");
      }
      try {
        await db.execute('ALTER TABLE users ADD COLUMN agency TEXT');
      } catch (e) {
        print("Coluna agency já existe ou erro: $e");
      }
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN balance REAL DEFAULT 0.0',
        );
      } catch (e) {
        print("Coluna balance já existe ou erro: $e");
      }

      await db.execute('''
        CREATE TABLE IF NOT EXISTS transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          senderUserId INTEGER,
          receiverAccountNumber TEXT,
          amount REAL,
          timestamp TEXT,
          description TEXT,
          type TEXT,
          FOREIGN KEY (senderUserId) REFERENCES users(id)
        )
      ''');
    }
  }

  static String hashPasswordStatic(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByCpf(String cpf) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'cpf = ?',
      whereArgs: [cpf],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByAccountNumber(String accountNumber) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'accountNumber = ?',
      whereArgs: [accountNumber],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> verifyPassword(String cpf, String password) async {
    User? user = await getUserByCpf(
      cpf,
    ); 
    if (user != null) {
      final hashedPasswordAttempt = DatabaseHelper.hashPasswordStatic(password);
      return user.password == hashedPasswordAttempt;
    }
    return false;
  }

  Future<List<User>> getAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update(
      'users',
      user.toMap(), 
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

 
  Future<int> updateUserBalance(int userId, double newBalance) async {

    Database db = await database;
    return await db.update(
      'users',
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> insertTransaction(TransactionModel transaction) async {

    Database db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactionsForUser(int userId) async {

    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where:
          'senderUserId = ? OR receiverAccountNumber = (SELECT accountNumber FROM users WHERE id = ?)',
      whereArgs: [userId, userId],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }


  Future<bool> performTransfer({
    required int senderUserId,
    required String receiverAccountNumber,
    required double amount,
    String? description,
    
  }) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        List<Map<String, dynamic>> senderMaps = await txn.query(
          'users',
          where: 'id = ?',
          whereArgs: [senderUserId],
        );
        if (senderMaps.isEmpty) throw Exception("Remetente não encontrado.");
        User sender = User.fromMap(senderMaps.first);
        if (sender.balance < amount) throw Exception("Saldo insuficiente.");

        List<Map<String, dynamic>> receiverMaps = await txn.query(
          'users',
          where: 'accountNumber = ?',
          whereArgs: [receiverAccountNumber],
        );
        if (receiverMaps.isEmpty)
          throw Exception("Conta de destino não encontrada.");
        User receiver = User.fromMap(receiverMaps.first);

        double newSenderBalance = sender.balance - amount;
        await txn.update(
          'users',
          {'balance': newSenderBalance},
          where: 'id = ?',
          whereArgs: [sender.id],
        );

        double newReceiverBalance = receiver.balance + amount;
        await txn.update(
          'users',
          {'balance': newReceiverBalance},
          where: 'id = ?',
          whereArgs: [receiver.id],
        );

        TransactionModel sentTransaction = TransactionModel(
          senderUserId: sender.id,
          receiverAccountNumber: receiver.accountNumber,
          amount: amount,
          timestamp: DateTime.now().toIso8601String(),
          description: description ?? 'Transferência para ${receiver.name}',
          type: 'TRANSFER_SENT',
        );
        await txn.insert('transactions', sentTransaction.toMapWithoutId());

        TransactionModel receivedTransaction = TransactionModel(
          senderUserId:
              sender
                  .id, 
          receiverAccountNumber:
              receiver.accountNumber, 
          amount: amount,
          timestamp: DateTime.now().toIso8601String(),
          description:
              description ?? 'Transferência recebida de ${sender.name}',
          type: 'TRANSFER_RECEIVED', 
        );
       
      });
      return true; 
    } catch (e) {
      print("Erro na transação: $e");
      return false; 
    }
  }
}
