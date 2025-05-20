import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/endereco_dialog.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/views/auth/login_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tarsobank/views/auth/success_screen.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var enderecoController = TextEditingController();
    var cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    ); 
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                  'Cadastre-se',
                  style: AppTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                
                // Campo Nome
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 5),
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
                const SizedBox(height: 5),
                //campo Telefone
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 5),
                // Campo Email
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 5),
                // Campo Endereço
                TextFormField(
                  controller: enderecoController,
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
                      enderecoController.text = resultado;
                    }
                  },
                ),
                const SizedBox(height: 5),

                // Campo Senha
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 5),
                // Campo Confirmar Senha
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true, 
                ),
                const SizedBox(height: 5),
                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SuccessScreen()),
                      );
                    },
                    child: const Text('Criar conta'),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Já possui uma conta?'),
                // Criar conta
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                    // Navegar para tela de cadastro
                  },
                  child: const Text('Entrar'),
                ),])
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
