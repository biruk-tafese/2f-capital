import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart'; // Import for Color class
import 'package:todochatapp/features/todo/data/model/response.dart';
import 'package:todochatapp/features/todo/data/model/todo_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('Todos');

class FirebaseDB {
  static Future<Response> addTodo({
    required String id, // Marked as required
    required String title, // Marked as required
    String? description, // Optional description of the todo
    required String type, // Marked as required
    required Color color, // Marked as required
    required bool isPinned, // Marked as required
    required String category, // Marked as required
    List<Map<String, dynamic>>? items, // Optional list of checklist items
    String? imageUrl, // Optional image URL
  }) async {
    Response response = Response();
    final DatabaseReference _dbRef =
        FirebaseDatabase.instance.ref('todos'); // Reference to the 'todos' node

    final DatabaseReference newTodoRef =
        _dbRef.child(id); // Create a new child reference for the todo

    // Constructing the data to save in Realtime Database
    Map<String, dynamic> data = <String, dynamic>{
      "id": id,
      "title": title,
      "description": description,
      "type": type,
      "color": color.value, // Store color as an integer value
      "pinned": isPinned,
      "category": category,
      "items": items ?? [], // Default to empty list if null
      "imageUrl": imageUrl,
    };

    try {
      await newTodoRef.set(data); // Use set to store the data
      response.code = 200;
      response.message = "Successfully added to the database";
    } catch (e) {
      response.code = 500;
      response.message =
          e.toString(); // Convert error to string for easier debugging
    }

    return response;
  }

  Stream<List<TodoModel>> readTodo() {
    final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

    return _dbRef.onValue.map((event) {
      final List<TodoModel> todos = [];

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          final todoData = Map<String, dynamic>.from(value);
          todos.add(TodoModel(
            id: key, // Use the key as the ID
            title: todoData['title'] ?? '',
            description: todoData['description'] ?? '',
            type: todoData['type'] ?? '',
            color: Color(todoData['color'] ?? 0xFFFFFFFF), // Default to white
            isPinned: todoData['pinned'] ?? false,
            category: todoData['category'] ?? '',
            items: List<Map<String, dynamic>>.from(todoData['items'] ?? []),
            imageUrl: todoData['imageUrl'] ?? '',
            createdBy: todoData['createdBy'] ?? '',
          ));
        });
      }
      print("Fetched todos: $todos"); // Debugging print statement
      return todos;
    });
  }

  Future<Response> updateTodo({
    required String id, // Unique identifier for the todo item
    required String title, // Title of the todo
    String? description, // Optional description of the todo
    required String type, // Type of todo (e.g., note, checklist, image)
    required Color color, // Color associated with the todo
    required bool isPinned, // Indicates if the todo is pinned
    required String category, // Category of the todo
    List<Map<String, dynamic>>? items, // Optional list of checklist items
    String? imageUrl, // Optional image URL
    required String docId, // Document ID for Firestore
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "id": id,
      "title": title,
      "description": description,
      "type": type,
      "color": color.value, // Store color as an integer
      "pinned": isPinned,
      "category": category,
      "items": items, // Optional list of checklist items
      "imageUrl": imageUrl,
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully updated Todo";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString(); // Ensure error is a string
    });

    return response;
  }

  Future<Response> deleteTodo({
    required String docId, // Document ID of the todo to be deleted
  }) async {
    Response response = Response();
    DocumentReference documentReferencer =
        _collection.doc(docId); // Use the correct collection reference

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Successfully deleted Todo"; // Corrected spelling
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString(); // Ensure error is a string
    });

    return response;
  }
}
