import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  Map<String, bool>? collaborators;
  final String userId;
  final String? email;
  bool isPinned;
  String date;
  String? category;
  String? type;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.collaborators,
    required this.userId,
    required this.email,
    required bool completed,
    required this.isPinned,
    required this.date,
    required this.category,
    required this.type,
  });

  // Convert a Todo object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'collaborators': collaborators,
      'userId': userId,
      'email': email,
      'isPinned': isPinned,
      'date': date,
      'category': category,
      'type': type,
    };
  }

  // Create a Todo object from a Firebase snapshot
  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      collaborators: Map<String, bool>.from(map['collaborators'] ?? {}),
      userId: map['userId'],
      email: map['email'],
      isPinned: map['isPinned'],
      date: map['date'],
      completed: map['completed'],
      category: map['category'],
      type: map['type'],
    );
  }

  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Todo(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] ?? '',
      email: data['email'] ?? '',
      collaborators: Map<String, bool>.from(data['collaborators'] ?? {}),
      isPinned: data['isPinned'] ?? false,
      date: data['date'] ?? '',
      completed: data['completed'] ?? false,
      category: data['category'] ?? '',
      type: data['type'] ?? '',
    );
  }
}
