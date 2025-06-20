import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/theme.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  const Icon(Icons.check, size: 70, color: Colors.white),
                ],
              ),
              const SizedBox(height: 40),
              Text('Parabéns!', style: AppTheme.loginTitle),
              const SizedBox(height: 8),
              // Texto secundário
              Text(
                'Conta registrada\ncom sucesso',
                style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botão "Ótimo!"
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
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
