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
      await _firestore.collection('todos').add({
        'title': todo.title,
        'description': todo.description,
        'userId': todo.userId, // Store the user's ID
        'email': todo.email, // Store the user's email
        'isPinned': todo.isPinned,
        'date': todo.date,
        'isCompleted': todo.isCompleted,
        'createdBy': todo.createdBy,
        'collaborators': todo.collaborators,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateTodo(Todo todo) async {
    await _firestore.collection('todos').doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isPinned': todo.isPinned,
      'date': todo.date,
    });
  }

  // Fetch todos for the logged-in user
  Stream<List<Todo>> getTodos() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('todos')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList());
    }
    return Stream.value([]);
  }

  // Update a todo
  Future<void> updateTodoStatus(String todoId, bool isCompleted) async {
    await _dbRef.child(todoId).update({'isCompleted': isCompleted});
  }

  // Delete a todo
  Future<void> deleteTodo(String todoId) async {
    await _dbRef.child(todoId).remove();
  }
}
