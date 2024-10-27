import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todochatapp/features/todo/data/firebase_db.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _typeController = TextEditingController();
  Color selectedColor = Colors.white; // Default color
  bool isPinned = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> checklistItems = [];
  String todoType = 'note'; // Default todo type
  String category = 'General'; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              if (todoType == 'note') // Show description only for notes
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              // Color picker for the todo
              Row(
                children: [
                  Text('Select Color:'),
                  IconButton(
                    icon: Icon(Icons.color_lens),
                    onPressed: _pickColor,
                  ),
                ],
              ),
              // Example toggle for pinned status
              Row(
                children: [
                  Text('Pin Todo'),
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
              // Button to save the todo
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text('Save Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickColor() async {
    Color? color = await showDialog<Color>(
      context: context,
      builder: (context) {
        Color tempColor = Colors.white; // Default color
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    if (color != null) {
      setState(() {
        selectedColor = color;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Response'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveTodo() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if the user is authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorDialog('You must be logged in to save todos');
        return;
      }

      // Prepare todo data
      var response = await FirebaseDB.addTodo(
        id: user.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        type: _typeController.text.isEmpty ? todoType : _typeController.text,
        color: selectedColor,
        isPinned: isPinned,
        category: _categoryController.text.isEmpty
            ? category
            : _categoryController.text,
        items: checklistItems.map((item) => {'item': item}).toList(),
        imageUrl: _imageUrlController.text,
      );

      // Show result message
      _showErrorDialog(response.message.toString());
    }
  }
}
