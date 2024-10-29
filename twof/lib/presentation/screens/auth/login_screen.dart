import 'package:flutter/material.dart';
import 'package:twof/core/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void _login() async {
    final user = await _authService.signIn(
        _emailController.text, _passwordController.text);
    if (user != null) {
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email')),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Password')),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
