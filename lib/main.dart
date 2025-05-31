import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/database/database_initializer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tarsobank/src/views/auth/login_screen.dart';
import 'package:tarsobank/src/views/auth/success_register_screen.dart';
import 'package:tarsobank/src/views/splash_screen.dart';
import 'package:tarsobank/src/views/auth/register_screen.dart';
import 'package:tarsobank/src/views/home/home_screen.dart';
import 'package:tarsobank/src/views/profile/profile_screen.dart';
import 'package:tarsobank/src/views/quotation/quotation_screen.dart';
import 'package:tarsobank/src/views/transfer/transfer_screen.dart';
import 'package:tarsobank/src/views/transfer/success_transfer_screen.dart';
import 'package:tarsobank/src/database/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await initializeTestUsers();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TarsoBank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/success_register': (context) => const SuccessScreen(),
        '/quotation': (context) => const QuotationScreen(),
      },

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final args = settings.arguments;
            if (args is User) {
              return MaterialPageRoute(
                builder: (context) => HomeScreen(user: args),
              );
            }

            return MaterialPageRoute(
              builder:
                  (context) =>
                      const Text('Erro: Usuário não fornecido para HomeScreen'),
            );

          case '/profile':
            final args = settings.arguments;
            if (args is User) {
              return MaterialPageRoute(
                builder: (context) => ProfileScreen(user: args),
              );
            }
            return MaterialPageRoute(
              builder:
                  (context) => const Text(
                    'Erro: Usuário não fornecido para ProfileScreen',
                  ),
            );

          case '/transfer':
            final args = settings.arguments;
            if (args is User) {
              return MaterialPageRoute(
                builder: (context) => TransferScreen(currentUser: args),
              );
            }
            return MaterialPageRoute(
              builder:
                  (context) => const Text(
                    'Erro: Usuário não fornecido para TransferScreen',
                  ),
            );

          case '/success_transfer':
            final Map<String, dynamic>? args =
                settings.arguments as Map<String, dynamic>?;
            if (args != null &&
                args['currentUser'] is User &&
                args['receiverName'] is String &&
                args['receiverAccountNumber'] is String &&
                args['amountTransferred'] is double &&
                args['transactionDateTime'] is DateTime) {
              return MaterialPageRoute(
                builder:
                    (context) => SuccessTransferScreen(
                      currentUser: args['currentUser'],
                      receiverName: args['receiverName'],
                      receiverAccountNumber: args['receiverAccountNumber'],
                      amountTransferred: args['amountTransferred'],
                      transactionDateTime: args['transactionDateTime'],
                      transactionDescription: args['transactionDescription'],
                    ),
              );
            }
            return MaterialPageRoute(
              builder:
                  (context) => const Text(
                    'Erro: Argumentos inválidos para SuccessTransferScreen',
                  ),
            );

          default:
            return null;
        }
      },
    );
  }
}
