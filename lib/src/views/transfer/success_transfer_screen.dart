import 'package:flutter/material.dart';
import 'package:tarsobank/src/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/home/home_screen.dart';

class SuccessTransferScreen extends StatelessWidget {
  final User currentUser; 

  const SuccessTransferScreen({super.key, required this.currentUser});

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
                  const Icon(
                    Icons.check_circle_outline, 
                    size: 70,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Sucesso!', // Título
                style: AppTheme.loginTitle?.copyWith(color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Transferência realizada\ncom sucesso',
                style: AppTheme.bodySmall?.copyWith( 
                  color: AppTheme.primaryDark, 
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(user: currentUser), 
                      ),
                      (Route<dynamic> route) => false, 
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Ótimo!',
                    style: AppTheme.buttonText?.copyWith(color: Colors.white) 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}