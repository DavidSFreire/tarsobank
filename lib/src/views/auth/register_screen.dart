import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/endereco_dialog.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/auth/login_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tarsobank/src/views/auth/success_register_screen.dart';
import 'package:tarsobank/src/database/local_db.dart';
import 'package:tarsobank/src/models/user_model.dart';
import 'dart:math';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  var numFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
  var cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  bool _isValidCpf(String cpf) {
    final cleanedCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedCpf.length != 11) return false;
    if (RegExp(r'(\d)\1{10}').hasMatch(cleanedCpf)) return false;

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleanedCpf[i]) * (10 - i);
    }
    int firstVerifier = (sum * 10) % 11;
    if (firstVerifier == 10) firstVerifier = 0;

    if (firstVerifier != int.parse(cleanedCpf[9])) return false;

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleanedCpf[i]) * (11 - i);
    }
    int secondVerifier = (sum * 10) % 11;
    if (secondVerifier == 10) secondVerifier = 0;

    return secondVerifier == int.parse(cleanedCpf[10]);
  }

  String _generateAccountNumber() {
    Random random = Random();
    String account = '';
    for (int i = 0; i < 6; i++) {
      account += random.nextInt(10).toString();
    }
    return account;
  }

  Future<void> _register() async {
    final String name = _nameController.text.trim();
    final String rawCpf = _cpfController.text;
    final String cpf = rawCpf.replaceAll('.', '').replaceAll('-', '').trim();
    final String phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '').trim();
    final String email = _emailController.text.trim();
    final String address = _addressController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || cpf.isEmpty || phone.isEmpty || email.isEmpty || address.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos.', Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('As senhas não coincidem.', Colors.red);
      return;
    }

    if (!_isValidCpf(rawCpf)) {
      _showSnackBar('CPF inválido.', Colors.red);
      return;
    }

    User? existingUser = await _dbHelper.getUserByCpf(cpf);
    if (existingUser != null) {
      _showSnackBar('CPF já cadastrado. Por favor, use outro CPF.', Colors.red);
      return;
    }

    final String accountNumber = _generateAccountNumber();
    const String agency = '0001';

    final String hashedPassword = DatabaseHelper.hashPasswordStatic(password);

    final User newUser = User(
      name: name,
      cpf: cpf,
      phone: phone,
      email: email,
      address: address,
      password: hashedPassword,
      accountNumber: accountNumber,
      agency: agency,
    );

    try {
      await _dbHelper.insertUser(newUser);
      _showSnackBar('Usuário cadastrado com sucesso!', Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } catch (e) {
      _showSnackBar('Erro ao cadastrar usuário: ${e.toString()}', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Cadastre-se'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryDark,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.cardShadows,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfFormatter],
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    hintText: '000.000.000-00',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [numFormatter],
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    hintText: '(00) 00000-0000',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _addressController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    prefixIcon: Icon(Icons.home),
                  ),
                  onTap: () async {
                    final resultado = await showDialog<String>(
                      context: context,
                      builder: (context) => const EnderecoDialog(),
                    );
                    if (resultado != null) {
                      _addressController.text = resultado;
                    }
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text('Criar conta'),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já possui uma conta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Entrar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}