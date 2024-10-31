import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/core/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:twof/core/theme/app_theme.dart';
import 'package:twof/presentation/screens/splash/splash_screen.dart';

// Define the background task callback
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Call your function to check for new messages here
    // Initialize NotificationService
    NotificationService notificationService = NotificationService();
    AuthService authService = AuthService();

    String? email = authService.getCurrentUser()?.email;

    // Periodically check for new messages (optional but recommended if background tasks are allowed)
    notificationService.checkForNewMessages(email);
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
