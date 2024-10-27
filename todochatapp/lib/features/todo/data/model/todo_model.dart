import 'package:flutter/material.dart';

class TodoModel {
  String id;
  String title;
  String? description;
  String type;
  Color color;
  bool isPinned;
  String category;
  List<Map<String, dynamic>>? items;
  String? imageUrl;
  String createdBy;
  List<String>? assignedUsers;
  int? lastEdited;
  String? editingUser;

  // Constructor
  TodoModel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.color,
    this.isPinned = false,
    required this.category,
    this.items,
    this.imageUrl,
    required this.createdBy,
    this.assignedUsers,
    this.lastEdited,
    this.editingUser,
  });

  // Factory method to create a TodoModel instance from a Map
  factory TodoModel.fromMap(Map<String, dynamic> data) {
    return TodoModel(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      type: data['type'],
      color:
          Color(data['color'] ?? 0xFFFFFFFF), // Default color if not provided
      isPinned: data['pinned'] ?? false,
      category: data['category'],
      items: data['items'] != null
          ? List<Map<String, dynamic>>.from(data['items'])
          : null,
      imageUrl: data['imageUrl'],
      createdBy: data['createdBy'],
      assignedUsers: data['assignedUsers'] != null
          ? List<String>.from(data['assignedUsers'])
          : null,
      lastEdited: data['lastEdited'],
      editingUser: data['editingUser'],
    );
  }

  // Method to convert a TodoModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'color': color.value, // Convert color to integer value
      'pinned': isPinned,
      'category': category,
      'items': items,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'assignedUsers': assignedUsers,
      'lastEdited': lastEdited,
      'editingUser': editingUser,
    };
  }
}
