import 'package:flutter/material.dart';
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/data/model/todo_model.dart';
import 'package:twof/core/services/todo_service.dart';
import 'package:twof/presentation/screens/home/home_screen.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  const EditTodoScreen({super.key, required this.todo});

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPinned = false;
  final TodoService _todoService = TodoService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.title ?? '';
    _descriptionController.text = widget.todo.description ?? '';
    _isPinned = widget.todo.isPinned;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTodo() async {
    final updatedTodo = Todo(
      id: widget.todo.id,
      title: _titleController.text,
      description: _descriptionController.text,
      isPinned: _isPinned,
      date: widget.todo.date,
      isCompleted: widget.todo.isCompleted,
      collaborators: widget.todo.collaborators,
      createdBy: _authService.getCurrentUser()?.email ?? 'unknown',
      userId: _authService.getCurrentUser()?.uid ?? 'unknown',
      email: _authService.getCurrentUser()?.email ?? 'unknown',
      completed: false,
    );

    await _todoService.updateTodo(updatedTodo);

    // Navigate back to the previous screen
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateTodo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            SwitchListTile(
              title: const Text('Pin this todo'),
              value: _isPinned,
              onChanged: (value) {
                setState(() {
                  _isPinned = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
