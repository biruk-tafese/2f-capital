import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todochatapp/features/todo/data/firebase_db.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todochatapp/features/todo/data/model/todo_model.dart';

class AddTodoPage extends StatefulWidget {
  final TodoModel? todo;

  const AddTodoPage({super.key, this.todo});

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

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref('todos'); // Reference to the todos node

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title ?? '';
      _descriptionController.text = widget.todo!.description ?? '';
      _imageUrlController.text = widget.todo!.imageUrl ?? '';
      _categoryController.text = widget.todo!.category ?? '';
      _typeController.text = widget.todo!.type ?? '';
      selectedColor = widget.todo!.color ?? Colors.white;
      isPinned = widget.todo!.isPinned ?? false;
      checklistItems = widget.todo!.items ?? [];
      todoType = widget.todo!.type ?? 'note';
      category = widget.todo!.category ?? 'General';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
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
                  if (todoType == 'note') ...[
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    _buildCategoryDropdown(),
                  ] else if (todoType == 'image') ...[
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                    ),
                    _buildCategoryDropdown(),
                  ] else if (todoType == 'items') ...[
                    // Add checklist items input here
                    _buildCategoryDropdown(),
                  ],
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
                    child:
                        Text(widget.todo == null ? 'Save Todo' : 'Update Todo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: category,
      decoration: InputDecoration(labelText: 'Category'),
      items: ['General', 'Work', 'Personal', 'Shopping']
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          category = value ?? 'General';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Category cannot be empty';
        }
        return null;
      },
    );
  }

  Future<void> _pickColor() async {
    Color tempColor =
        selectedColor; // Use the current selected color as the initial color

    Color? color = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: tempColor,
              onColorChanged: (newColor) {
                tempColor = newColor;
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
      var todoData = {
        'id': user.uid,
        'title': _titleController.text,
        'description': todoType == 'note' ? _descriptionController.text : '',
        'type': _typeController.text.isEmpty ? todoType : _typeController.text,
        'color': selectedColor.value, // Save color as an int
        'isPinned': isPinned,
        'category': category,
        'items': todoType == 'items'
            ? checklistItems.map((item) => {'item': item}).toList()
            : [],
        'imageUrl': todoType == 'image' ? _imageUrlController.text : '',
        'lastEditedBy': user.email, // Save the email of the last editor
        'lastEditedAt':
            DateTime.now().toIso8601String(), // Save the current timestamp
      };

      // Save the todo to the database
      if (widget.todo == null) {
        await _dbRef.child(user.uid).push().set(todoData);
        _showErrorDialog('Todo saved successfully!');
      } else {
        await _dbRef.child(user.uid).child(widget.todo!.id).update(todoData);
        _showErrorDialog('Todo updated successfully!');
      }
    }
  }
}
