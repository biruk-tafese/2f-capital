// lib/presentation/screens/todos/todo_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/core/services/todo_service.dart';
import 'package:twof/data/model/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoService _todoService = TodoService();
  final AuthService _authService = AuthService();

  void _showAddTodoDialog(BuildContext context, bool isEdit, Todo? todo) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();
    bool isPinned = false; // Default pin status

    if (isEdit && todo != null) {
      titleController.text = todo.title;
      descriptionController.text = todo.description;
      dateController.text = todo.date;
      isPinned = todo.isPinned; // Assuming `isPinned` is a property of Todo
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Task',
                    icon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    icon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Date',
                    icon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pin Todo'),
                    Switch(
                      value: isPinned,
                      onChanged: (value) {
                        setState(() {
                          isPinned = value;
                        });
                      },
                    ),
                  ],
                ),
                // Add a dropdown for categories if needed
                const SizedBox(height: 15),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(isEdit ? 'Update' : 'Add'),
              onPressed: () {
                final newTodo = Todo(
                  id: isEdit ? todo!.id : DateTime.now().toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  date: dateController.text,
                  isPinned: isPinned,
                  completed: false,
                  createdBy: '',
                  collaborators: {},
                  userId: _authService.getCurrentUser()!.uid,
                  email: _authService.getCurrentUser()!.email,
                );

                if (isEdit) {
                  _todoService.updateTodo(
                      newTodo); // Implement update method in your TodoService
                } else {
                  _todoService.addTodo(
                      newTodo); // Implement add method in your TodoService
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Todos'),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _todoService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Todos available.'));
          }

          final todos = snapshot.data!;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showAddTodoDialog(context, true, todo);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context, false, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
