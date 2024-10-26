import 'package:flutter/material.dart';

class TodoModel {
  String id; // Unique identifier for the todo item
  String title; // Title of the todo
  String? description; // Optional description of the todo
  String type; // Type of todo (e.g., note, checklist, image)
  Color color; // Color associated with the todo
  bool isPinned; // Indicates if the todo is pinned
  String category; // Category of the todo
  List<Map<String, dynamic>>? items; // Optional list of checklist items
  String? imageUrl; // Optional image URL

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
  });

  // Factory method to create a Todo instance from a Map
  factory TodoModel.fromMap(Map<String, dynamic> data) {
    return TodoModel(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      type: data['type'],
      color: data['color'] ?? Colors.white, // Default color if not provided
      isPinned: data['pinned'] ?? false,
      category: data['category'],
      items: data['items'] != null
          ? List<Map<String, dynamic>>.from(data['items'])
          : null,
      imageUrl: data['imageUrl'],
    );
  }

  // Method to convert a Todo instance to a Map
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
    };
  }
}
