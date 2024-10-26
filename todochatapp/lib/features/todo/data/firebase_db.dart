import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Import for Color class
import 'package:todochatapp/features/todo/model/response.dart';
import 'package:todochatapp/features/todo/model/todo_model.dart';

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
    DocumentReference documentReferencer = _collection.doc();

    // Constructing the data to save in Firestore
    Map<String, dynamic> data = <String, dynamic>{
      "id": id,
      "title": title,
      "description": description,
      "type": type,
      "color": color.value, // Store color as an integer value
      "pinned": isPinned,
      "category": category,
      "items": items,
      "imageUrl": imageUrl,
    };

    try {
      await documentReferencer.set(data);
      response.code = 200;
      response.message = "Successfully added to the database";
    } catch (e) {
      response.code = 500;
      response.message =
          e.toString(); // Convert error to string for easier debugging
    }

    return response;
  }

  static Stream<List<TodoModel>> readTodo() {
    CollectionReference notesItemCollection = _collection;

    return notesItemCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TodoModel(
          id: doc[
              'id'], // Ensure your Todo model has the appropriate constructor
          title: doc['title'],
          description: doc['description'],
          type: doc['type'],
          color: Color(doc['color']), // Convert int back to Color
          isPinned: doc['pinned'],
          category: doc['category'],
          items: List<Map<String, dynamic>>.from(
              doc['items'] ?? []), // Convert to List
          imageUrl: doc['imageUrl'],
        );
      }).toList();
    });
  }

  static Future<Response> updateTodo({
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

  static Future<Response> deleteTodo({
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
