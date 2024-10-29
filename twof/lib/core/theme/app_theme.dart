// lib/core/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0088CC); // Telegram Blue
  static const Color secondaryColor = Color(0xFF00BFFF); // Lighter Blue
  static const Color backgroundColor =
      Color(0xFFF5F7FA); // Light Grey Background
  static const Color textColor = Colors.black; // Main Text Color
  static const Color inputBorderColor = Color(0xFFB0BEC5); // Input Border Color
  static const Color hintTextColor = Color(0xFF757575); // Hint Text Color
  static const Color buttonColor = Color(0xFF0088CC); // Button Color

  static final ThemeData theme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        borderSide: const BorderSide(color: inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        borderSide: const BorderSide(color: primaryColor),
      ),
      hintStyle: const TextStyle(color: hintTextColor),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded button
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
  );
}
