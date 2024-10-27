import 'package:firebase_database/firebase_database.dart';
import 'package:todochatapp/features/todo/data/model/todo_model.dart';

class FirebaseDB {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Fetch Todos in real-time and listen to changes
  Stream<List<TodoModel>> getTodosStream() {
    final todosRef = _db.child('todos');

    return todosRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.entries.map((entry) {
          final todoData = Map<String, dynamic>.from(entry.value);
          return TodoModel.fromMap(todoData);
        }).toList();
      }
      return [];
    });
  }

  // Add a new Todo
  Future<void> addTodo(TodoModel todo) async {
    final newTodoRef = _db.child('todos').push();
    await newTodoRef.set(todo.toMap());
  }

  // Update an existing Todo (for real-time collaboration)
  Future<void> updateTodo(TodoModel todo, String userId) async {
    final todoRef = _db.child('todos/${todo.id}');

    // Set fields to be updated in the todo
    await todoRef.update({
      ...todo.toMap(),
      'lastEdited': ServerValue.timestamp,
      'editingUser': userId,
    });
  }

  // Track when a user starts editing a todo
  Future<void> startEditing(String todoId, String userId) async {
    final todoRef = _db.child('todos/$todoId');

    await todoRef.update({
      'editingUser': userId,
      'lastEdited': ServerValue.timestamp,
    });
  }

  // Track when a user stops editing a todo
  Future<void> stopEditing(String todoId) async {
    final todoRef = _db.child('todos/$todoId');

    await todoRef.update({
      'editingUser': null,
    });
  }

  // Delete a Todo
  Future<void> deleteTodo(String todoId) async {
    final todoRef = _db.child('todos/$todoId');
    await todoRef.remove();
  }
}
