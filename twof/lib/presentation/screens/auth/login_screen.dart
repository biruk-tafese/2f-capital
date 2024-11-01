import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/core/theme/app_theme.dart';
import 'package:twof/presentation/screens/auth/signup_screen.dart';
import 'package:twof/presentation/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  bool _rememberMe = false; // Track the state of the "Remember Me" checkbox

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check if the user is already logged in
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      // User is logged in, navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await _authService.signIn(
          _emailController.text, _passwordController.text);
      if (user != null) {
        // Save the "Remember Me" preference
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          // Save the email and login status if "Remember Me" is checked
          prefs.setString('email', _emailController.text);
          prefs.setBool('isLoggedIn', true);
        } else {
          // Clear saved email and login status
          prefs.remove('email');
          prefs.setBool('isLoggedIn', false);
        }

        // Navigate to home screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }

  void _forgotPassword() {
    // Navigate to Forgot Password Screen or implement your logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Forgot Password functionality not implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add more email validation if needed
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login',
                        style: TextStyle(
                          color: Colors.white,
                        ))),
                TextButton(
                  onPressed: _forgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()),
                              (route) => false);
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
