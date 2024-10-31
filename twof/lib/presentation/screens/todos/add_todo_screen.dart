import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twof/core/services/todo_service.dart';
import 'package:twof/data/model/todo_model.dart';
import 'package:uuid/uuid.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TodoService todoService = TodoService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _collaboratorsController =
      TextEditingController();
  DateTime? _selectedDate;
  bool _isPinned = false;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitTodo() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      setState(() {
        _isLoading = true;
      });

      // Generate a unique ID for the todo item
      String todoId = const Uuid().v4();

      // Convert collaborators input to Map<String, bool>
      Map<String, bool> collaboratorsMap = {};
      List<String> collaboratorsList = _collaboratorsController.text.split(',');
      for (String collaborator in collaboratorsList) {
        String email = collaborator.trim();
        if (email.isNotEmpty) {
          collaboratorsMap[email] =
              true; // Default status for each collaborator
        }
      }

      // Create a Todo object
      Todo newTodo = Todo(
        id: todoId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        isPinned: _isPinned,
        date: _selectedDate!.toIso8601String(),
        isCompleted: false,
        createdBy: FirebaseAuth.instance.currentUser?.displayName ?? '',
        collaborators: collaboratorsMap,
        completed: false, // Use Map<String, bool>
      );

      // Add the new todo to Firebase
      await todoService.addTodo(newTodo);

      setState(() {
        _isLoading = false;
      });

      // Clear the form
      _titleController.clear();
      _descriptionController.clear();
      _collaboratorsController.clear();
      _selectedDate = null;
      _isPinned = false;

      // Navigate back
      Navigator.of(context).pop();
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                      'Date: ${_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : 'Not selected'}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              CheckboxListTile(
                title: const Text("Pin this task"),
                value: _isPinned,
                onChanged: (newValue) {
                  setState(() {
                    _isPinned = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              TextFormField(
                controller: _collaboratorsController,
                decoration: const InputDecoration(
                    labelText: 'Collaborators (comma-separated emails)'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitTodo,
                      child: const Text('Add Todo'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
