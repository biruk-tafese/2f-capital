// lib/presentation/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/presentation/screens/auth/login_screen.dart';
import 'package:twof/presentation/screens/auth/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  // Check if the user is already logged in
  Future<void> _checkUserLoggedIn() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay for animation
    // Replace with your actual auth service logic to check if the user is logged in
    bool isLoggedIn = await AuthService().isLoggedIn();

    // Navigate to the appropriate screen based on login status
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue, // Set your background color
      body: Center(
        child: AnimatedText(), // Call the animated text widget
      ),
    );
  }
}

// Widget for animating the text
class AnimatedText extends StatefulWidget {
  const AnimatedText({super.key});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat animation

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Text(
        'Welcome to TwoF App',
        style: TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
