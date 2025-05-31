import 'package:tarsobank/src/database/local_db.dart';
import 'package:tarsobank/src/database/models/user_model.dart';

Future<void> initializeTestUsers() async {
  final dbHelper = DatabaseHelper();

  const String testCpf1 = '73164893086';
  const String testPassword1 = 'senha123';
  const String testAccountNumber1 = '123456';

  User? existingTestUser1 = await dbHelper.getUserByCpf(testCpf1);

  if (existingTestUser1 == null) {
    final String hashedPassword1 = DatabaseHelper.hashPasswordStatic(
      testPassword1,
    );

    final User testUser1 = User(
      name: 'Paulo',
      cpf: testCpf1,
      phone: '9912345678',
      email: 'teste1@tarsobank.com',
      address: 'Rua de Teste, 100 - Centro - Cidade Fictícia, UF',
      password: hashedPassword1,
      accountNumber: testAccountNumber1,
      agency: '0001',
    );

    try {
      await dbHelper.insertUser(testUser1);
      print(
        '>>> Usuário teste "${testUser1.name}" (CPF: ${testUser1.cpf}) inserido com sucesso!',
      );
    } catch (e) {
      print('>>> Erro ao inserir usuário teste 1: $e');
    }
  } else {
    print(
      '>>> Usuário teste "${existingTestUser1.name}" (CPF: ${existingTestUser1.cpf}) já existe.',
    );
  }

  const String testCpf2 = '84253962041';
  const String testPassword2 = 'senha321';
  const String testAccountNumber2 = '012345';

  User? existingTestUser2 = await dbHelper.getUserByCpf(testCpf2);

  if (existingTestUser2 == null) {
    final String hashedPassword2 = DatabaseHelper.hashPasswordStatic(
      testPassword2,
    );

    final User testUser2 = User(
      name: 'Vyctor Kelvin',
      cpf: testCpf2,
      phone: '9987654321',
      email: 'teste2@tarsobank.com',
      address: 'Avenida Testando, 200 - Bairro Demo - Cidade Fictícia, UF',
      password: hashedPassword2,
      accountNumber: testAccountNumber2,
      agency: '0001',
    );

    try {
      await dbHelper.insertUser(testUser2);
      print(
        '>>> Usuário teste "${testUser2.name}" (CPF: ${testUser2.cpf}) inserido com sucesso!',
      );
    } catch (e) {
      print('>>> Erro ao inserir usuário teste 2: $e');
    }
  } else {
    print(
      '>>> Usuário teste "${existingTestUser2.name}" (CPF: ${existingTestUser2.cpf}) já existe.',
    );
  }
}
