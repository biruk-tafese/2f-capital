import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String todoType = 'note'; // Default to 'note'
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> checklistItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 10),
            if (todoType == 'note' || todoType == 'checklist') ...[
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 10),
            ],
            DropdownButton<String>(
              value: todoType,
              onChanged: (String? newValue) {
                setState(() {
                  todoType = newValue!;
                });
              },
              items: <String>['note', 'image', 'checklist']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (todoType == 'checklist') ...[
              ElevatedButton(
                onPressed: () {
                  _addChecklistItem();
                },
                child: const Text("Add Checklist Item"),
              ),
              const SizedBox(height: 10),
              ...checklistItems.map((item) {
                return Row(
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
                        decoration: const InputDecoration(
                          hintText: 'Checklist item',
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _saveTodo();
              },
              child: const Text("Save Todo"),
            ),
          ],
        ),
      ),
    );
  }

  void _addChecklistItem() {
    setState(() {
      checklistItems.add({'name': '', 'done': false});
    });
  }

  void _saveTodo() {
    // Here, you can process and save the todo
    // You can pass the collected data to your backend or local storage
    // For simplicity, this code just prints the data

    if (todoType == 'checklist') {
      print('Checklist Todo: ${titleController.text}');
      print('Items: $checklistItems');
    } else {
      print('Todo Title: ${titleController.text}');
      print('Todo Description: ${descriptionController.text}');
    }

    Navigator.pop(context); // Go back to the todos page
  }
}
