import 'package:firebase_database/firebase_database.dart';
import 'package:twof/data/model/todo_model.dart';

class TodoService {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('todos');

  // Add a new todo
  Future<void> addTodo(Todo todo) async {
    final newTodoRef = _dbRef.push();
    await newTodoRef.set(todo.toMap());
  }

  // Fetch all todos with real-time updates
  Stream<List<Todo>> getTodos() {
    return _dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.entries
            .map((e) => Todo.fromMap(e.key, Map<String, dynamic>.from(e.value)))
            .toList();
      } else {
        return [];
      }
    });
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
