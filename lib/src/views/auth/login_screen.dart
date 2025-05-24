import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/auth/register_screen.dart';
import 'package:tarsobank/src/views/home/home_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    ); 
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
                // Título
                Text(
                  'Bem-vindo',
                  style: AppTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Campo CPF
                TextFormField(
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

                // Campo Senha
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text('Entrar'),
                  ),
                ),
                const SizedBox(height: 12),

                // Criar conta
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
