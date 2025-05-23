import 'package:flutter/material.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/splash_screen.dart';
import 'package:tarsobank/src/database/database_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeTestUser();
  
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
      home: const SplashScreen(),
    );
  }
}