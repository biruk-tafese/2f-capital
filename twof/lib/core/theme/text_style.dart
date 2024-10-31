import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle todoTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle todoDescription = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  static const TextStyle pinnedLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const TextStyle searchHint = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );
}

class AppColors {
  static const Color pinnedColor = Colors.blueAccent;
  static const Color regularTodoColor = Colors.white;
  static Color backgroundColor = Colors.grey[200]!;
}
