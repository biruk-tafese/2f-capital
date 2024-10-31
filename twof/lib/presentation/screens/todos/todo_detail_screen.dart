import 'package:flutter/material.dart';
import 'package:twof/data/model/todo_model.dart';
import 'package:twof/core/services/todo_service.dart';
import 'package:twof/presentation/screens/todos/edit_todo_screen.dart'; // Import your TodoService

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final TodoService todoService = TodoService();

    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title ?? 'Todo Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTodoScreen(
                          todo: todo))); // Call the update method
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Show confirmation dialog before deleting
              bool? confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content:
                      const Text('Are you sure you want to delete this todo?'),
                  actions: [
                    TextButton(
                      onPressed: () => todoService.deleteTodo(todo.id),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                // Call the delete method from your TodoService
                await todoService.deleteTodo(todo.id);
                Navigator.pop(context); // Go back to the previous screen
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title ?? 'Untitled',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              todo.description ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Pinned: ${todo.isPinned ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
