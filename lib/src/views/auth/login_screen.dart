import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/auth/register_screen.dart';
import 'package:tarsobank/src/views/home/home_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tarsobank/src/database/local_db.dart';
import 'package:tarsobank/src/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  var cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  Future<void> _login() async {
    final String rawCpf = _cpfController.text;
    final String cpf = rawCpf.replaceAll('.', '').replaceAll('-', '');
    final String password = _passwordController.text;

    if (cpf.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos.', Colors.red);
      return;
    }

    if (!_isValidCpf(rawCpf)) {
      _showSnackBar('CPF inválido. Verifique o formato.', Colors.red);
      return;
    }

    User? user = await _dbHelper.getUserByCpf(cpf);
    bool isAuthenticated = false;

    if (user != null) {
      isAuthenticated = await _dbHelper.verifyPassword(cpf, password);
    }

    if (isAuthenticated) {
      _showSnackBar('Login bem-sucedido!', Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user!)),
      );
    } else {
      _showSnackBar('CPF ou senha inválidos.', Colors.red);
    }
  }

  bool _isValidCpf(String cpf) {
    final cleanedCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedCpf.length != 11) {
      return false;
    }
    if (RegExp(r'(\d)\1{10}').hasMatch(cleanedCpf)) {
      return false;
    }

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleanedCpf[i]) * (10 - i);
    }
    int firstVerifier = (sum * 10) % 11;
    if (firstVerifier == 10) firstVerifier = 0;
    if (firstVerifier != int.parse(cleanedCpf[9])) {
      return false;
    }

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleanedCpf[i]) * (11 - i);
    }
    int secondVerifier = (sum * 10) % 11;
    if (secondVerifier == 10) secondVerifier = 0;
    if (secondVerifier != int.parse(cleanedCpf[10])) {
      return false;
    }

    return true;
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
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
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
                Text(
                  'Bem-vindo',
                  style: AppTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}