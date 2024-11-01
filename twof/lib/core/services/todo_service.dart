import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:twof/data/model/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('todos');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new todo
  Future<void> addTodo(Todo todo) async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Create a unique key for the todo item
      String todoId = _dbRef.push().key ?? DateTime.now().toString();

      // Store the todo in Realtime Database
      await _dbRef.child(todoId).set({
        'id': todoId, // Store a unique ID for the todo
        'title': todo.title,
        'description': todo.description,
        'userId': user.uid, // Store the user's ID
        'email': user.email, // Store the user's email
        'isPinned': todo.isPinned,
        'date': todo.date,
        'isCompleted': todo.isCompleted,
        'category': todo.category,
        'type': todo.type,
        'collaborators': todo.collaborators, // Store collaborators
        'timestamp': ServerValue.timestamp, // Use server timestamp
      });

      // Optionally store it in Firestore
      await _firestore.collection('todos').doc(todoId).set({
        'title': todo.title,
        'description': todo.description,
        'userId': user.uid,
        'email': user.email,
        'isPinned': todo.isPinned,
        'date': todo.date,
        'isCompleted': todo.isCompleted,
        'category': todo.category,
        'type': todo.type,
        'collaborators': todo.collaborators, // Store collaborators in Firestore
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Update a todo
  Future<void> updateTodo(Todo todo) async {
    await _dbRef.child(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isPinned': todo.isPinned,
      'date': todo.date,
      'category': todo.category,
      'type': todo.type,
      'isCompleted': todo.isCompleted, // Update completion status
      'collaborators': todo.collaborators, // Update collaborators
    });

    await _firestore.collection('todos').doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isPinned': todo.isPinned,
      'date': todo.date,
      'category': todo.category,
      'type': todo.type,
      'isCompleted': todo.isCompleted, // Update completion status
      'collaborators': todo.collaborators, // Update collaborators in Firestore
    });
  }

  // Fetch todos for all users (collaborative)
  Stream<List<Todo>> getTodos() {
    return _dbRef.onValue.map((event) {
      final todosMap = event.snapshot.value as Map<dynamic, dynamic>?;
      if (todosMap != null) {
        return todosMap.entries.map((entry) {
          final todoData = entry.value;
          return Todo(
            id: entry.key.toString(),
            title: todoData['title'],
            description: todoData['description'],
            userId: todoData['userId'],
            email: todoData['email'],
            isPinned: todoData['isPinned'],
            date: todoData['date'],
            isCompleted: todoData['isCompleted'],
            collaborators: todoData['collaborators'],
            category: todoData['category'],
            type: todoData['type'],
            completed: false,
          );
        }).toList();
      }
      return [];
    });
  }

  // Update a todo status
  Future<void> updateTodoStatus(String todoId, bool isCompleted) async {
    await _dbRef.child(todoId).update({'isCompleted': isCompleted});
  }

  // Delete a todo
  Future<void> deleteTodo(String todoId) async {
    await _dbRef.child(todoId).remove();
    await _firestore
        .collection('todos')
        .doc(todoId)
        .delete(); // Optionally delete from Firestore
  }
}
