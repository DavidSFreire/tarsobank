import 'package:tarsobank/src/database/local_db.dart';
import 'package:tarsobank/src/models/user_model.dart';

Future<void> initializeTestUser() async {
  final dbHelper = DatabaseHelper();

  const String testCpf = '73164893086';
  const String testPassword = 'senha123';

  User? existingTestUser = await dbHelper.getUserByCpf(testCpf);

  if (existingTestUser == null) {
    final String hashedPassword = DatabaseHelper.hashPasswordStatic(testPassword);

    final User testUser = User(
      name: 'Usuario Teste',
      cpf: testCpf,
      phone: '9912345678',
      email: 'teste@tarsobank.com',
      address: 'Rua de Teste, 100 - Centro - Cidade Fictícia, UF',
      password: hashedPassword,
      accountNumber: '123456',
      agency: '0001',
    );

    try {
      await dbHelper.insertUser(testUser);
      print('>>> Usuário teste "${testUser.name}" inserido com sucesso!');
    } catch (e) {
      print('>>> Erro ao inserir usuário teste: $e');
      print(e);
    }
  } else {
    print('>>> Usuário teste "${existingTestUser.name}" já existe no banco de dados.');
  }
}