import 'package:flutter/material.dart';
import 'package:twof/core/services/todo_service.dart';
import 'package:twof/data/model/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _todoService.getTodos().listen((todos) {
      setState(() {
        _todos = todos;
      });
    });
  }

  void _addTodo() {
    final newTodo = Todo(
      id: '',
      title: 'New Todo',
      description: 'This is a new todo item.',
      createdBy: 'userId',
      collaborators: {},
    );
    _todoService.addTodo(newTodo);
  }

  void _toggleTodoCompletion(Todo todo) {
    _todoService.updateTodoStatus(todo.id, !todo.isCompleted);
  }

  void _deleteTodo(String todoId) {
    _todoService.deleteTodo(todoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description),
            trailing: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => _toggleTodoCompletion(todo),
            ),
            onLongPress: () => _deleteTodo(todo.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
