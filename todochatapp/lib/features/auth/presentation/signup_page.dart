import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todochatapp/features/app/home_page.dart';
import 'package:todochatapp/features/auth/data/firebase_auth_services.dart';
import 'package:todochatapp/features/auth/presentation/login_page.dart';
import 'package:todochatapp/features/common/widgets/form_container_widget.dart';
import 'package:todochatapp/features/global/common/toast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool isSigningUp = false;

  // Simple email validation regex
  final RegExp _emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  // Function to validate email
  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  // Function to check if the passwords match
  bool _doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Function to handle signup logic
  // void _handleSignup() {
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //   String confirmPassword = _confirmPasswordController.text;
  //   String username = _usernameController.text;

  //   if (!_isEmailValid(email)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter a valid email address')),
  //     );
  //     return;
  //   }

  //   if (password.isEmpty || confirmPassword.isEmpty || username.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Above fields cannot be empty')),
  //     );
  //     return;
  //   }

  //   if (!_doPasswordsMatch(password, confirmPassword)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Passwords do not match')),
  //     );
  //     return;
  //   }

  //   // If all validation passes, navigate to HomePage
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomePage()),
  //       (route) => false);
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                FormContainerWidget(
                  controller: _usernameController,
                  hintText: 'UserName',
                  isPasswordField: false,
                ),
                const SizedBox(height: 30),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: 'Email',
                  isPasswordField: false,
                ),
                const SizedBox(height: 30),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPasswordField: true,
                ),
                const SizedBox(height: 30),
                FormContainerWidget(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPasswordField: true,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _signUp,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: isSigningUp
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Signup",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do you have an account?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "user is created");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      showToast(message: "user is not created");
    }
  }
}
