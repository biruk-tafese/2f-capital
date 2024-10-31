// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up method
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Create a new UserPresence document for the signed-up user
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'isOnline': false, // Initial presence state
          'lastSeen': DateTime.now().millisecondsSinceEpoch,
        });
      }

      return user; // Return the user object
    } catch (e) {
      // Handle error
      print("Error signing up: $e");
      return null;
    }
  }

  // Sign in method
  Future<User?> signIn(String email, String password,
      {bool rememberMe = false}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Save login state if rememberMe is true
      if (rememberMe && user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email); // Optional: save user email
      }

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ??
        false; // Returns true if user is logged in
  }

  // Fetch the saved email of the logged-in user
  Future<String?> getSavedUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail'); // Returns the saved email
  }

  Future<List<String>> fetchUserEmails() async {
    try {
      // Fetch users from Firestore
      final usersSnapshot = await _firestore.collection('users').get();

      // Extract emails from the documents
      final List<String> userEmails = usersSnapshot.docs
          .map((doc) => doc.data()['email'] as String)
          .where((email) => email.isNotEmpty)
          .toList();

      return userEmails;
    } catch (e) {
      print("Error fetching user emails: $e");
      return []; // Return an empty list in case of error
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();

    // Clear the login state from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail'); // Optional: clear the saved email
  }
}
