import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tarsobank/src/database/local_db.dart';
import 'package:tarsobank/src/database/models/user_model.dart';
import 'package:validadores/validadores.dart';

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
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _login() async {
    final String rawCpfWithMask = _cpfController.text;
    final String password = _passwordController.text;

    if (rawCpfWithMask.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos.', Colors.red);
      return;
    }

    String? cpfValidationError = Validador()
        .add(Validar.CPF, msg: 'CPF inválido. Verifique o formato.')
        .validar(rawCpfWithMask);

    if (cpfValidationError != null) {
      _showSnackBar(cpfValidationError, Colors.red);
      return;
    }

    final String cleanedCpfForDb = rawCpfWithMask.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );

    User? user = await _dbHelper.getUserByCpf(cleanedCpfForDb);
    bool isAuthenticated = false;

    if (user != null) {
      isAuthenticated = await _dbHelper.verifyPassword(
        cleanedCpfForDb,
        password,
      );
    }

    if (isAuthenticated && mounted) {
      _showSnackBar('Login bem-sucedido!', Colors.green);
      Navigator.pushReplacementNamed(context, '/home', arguments: user!);
    } else {
      _showSnackBar('CPF ou senha inválidos.', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
    }
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
                  decoration: const InputDecoration(
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
                    border: OutlineInputBorder(),
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
                    Navigator.pushNamed(context, '/register');
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
