import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/views/auth/login_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco como no design
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(
                    Icons.check,
                    size: 70,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Parabéns!',
                style: AppTheme.loginTitle,
              ),
              const SizedBox(height: 8),
              // Texto secundário
              Text(
                'Conta registrada\ncom sucesso',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryDark.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botão "Ótimo!"
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen  (),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Ótimo!', style: AppTheme.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
