import 'package:flutter/material.dart';
import 'package:twof/core/services/auth_services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void _signup() async {
    final user = await _authService.signUp(
        _emailController.text, _passwordController.text);
    if (user != null) {
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
            ElevatedButton(onPressed: _signup, child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
