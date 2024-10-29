// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up method
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user; // Return the user object
    } catch (e) {
      // Handle error
      print("Error signing up: $e");
      return null;
    }
  }

  // Sign in method
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user; // Return the user object
    } catch (e) {
      // Handle error
      print("Error signing in: $e");
      return null;
    }
  }

  // Get the currently logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null; // Returns true if user is logged in
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
