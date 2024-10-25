import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String todoType = 'note';
  String category = 'Personal';
  bool isPinned = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> checklistItems = [];
  File? imageFile; // File to store the selected image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue!;
                  });
                },
                items: [
                  'Personal',
                  'Work',
                  'Shopping',
                  'Cooking',
                  'Travel',
                  'Miscellaneous'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pin this Todo"),
                  Switch(
                    value: isPinned,
                    onChanged: (bool newValue) {
                      setState(() {
                        isPinned = newValue;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: todoType,
                decoration: InputDecoration(
                  labelText: 'Todo Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    todoType = newValue!;
                    imageFile = null; // Clear the image when switching types
                  });
                },
                items: ['note', 'image', 'checklist']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              if (todoType == 'note') ...[
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 3,
                ),
              ] else if (todoType == 'image') ...[
                const SizedBox(height: 16),
                imageFile != null
                    ? Image.file(
                        imageFile!,
                        height: 200,
                      )
                    : ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Upload Image"),
                      ),
              ] else if (todoType == 'checklist') ...[
                ElevatedButton(
                  onPressed: _addChecklistItem,
                  child: const Text("Add Checklist Item"),
                ),
                const SizedBox(height: 10),
                ...checklistItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item['done'],
                          onChanged: (bool? value) {
                            setState(() {
                              item['done'] = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (newValue) {
                              item['name'] = newValue;
                            },
                            decoration: InputDecoration(
                              hintText: 'Checklist item',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTodo,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Save Todo",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _addChecklistItem() {
    setState(() {
      checklistItems.add({'name': '', 'done': false});
    });
  }

  void _saveTodo() {
    final newTodo = {
      'title': titleController.text,
      'description': todoType == 'note' ? descriptionController.text : null,
      'type': todoType,
      'category': category,
      'pinned': isPinned,
      'color': Colors.blue.shade200,
      'items': todoType == 'checklist' ? checklistItems : null,
      'imageFile':
          todoType == 'image' ? imageFile : null, // Store File if image type
    };

    print('New Todo: $newTodo');
    Navigator.pop(context);
  }
}
