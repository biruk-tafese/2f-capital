import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  String createdBy;
  Map<String, bool>? collaborators;
  final String userId;
  final String? email;
  bool isPinned;
  String date;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdBy,
    required this.collaborators,
    required this.userId,
    required this.email,
    required bool completed,
    required this.isPinned,
    required this.date,
  });

  // Convert a Todo object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdBy': createdBy,
      'collaborators': collaborators,
      'userId': userId,
      'email': email,
      'isPinned': isPinned,
      'date': date,
    };
  }

  // Create a Todo object from a Firebase snapshot
  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      createdBy: map['createdBy'],
      collaborators: Map<String, bool>.from(map['collaborators'] ?? {}),
      userId: map['userId'],
      email: map['email'],
      isPinned: map['isPinned'],
      date: map['date'],
      completed: map['completed'],
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
      createdBy: data['createdBy'] ?? '',
      collaborators: Map<String, bool>.from(data['collaborators'] ?? {}),
      isPinned: data['isPinned'] ?? false,
      date: data['date'] ?? '',
      completed: data['completed'] ?? false,
    );
  }
}
