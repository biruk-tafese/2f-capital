import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twof/core/theme/app_theme.dart';
import 'package:twof/presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
