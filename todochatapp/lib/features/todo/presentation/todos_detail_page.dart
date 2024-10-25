import 'package:flutter/material.dart';

class TodoDetailPage extends StatefulWidget {
  final Map<String, dynamic> todo;

  const TodoDetailPage({super.key, required this.todo});

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo['title']);
    _descriptionController =
        TextEditingController(text: widget.todo['description']);
    _items = List<Map<String, dynamic>>.from(widget.todo['items'] ?? []);
  }

  void _updateTodo() {
    // Logic to update the Todo item
    String updatedTitle = _titleController.text;
    String updatedDescription = _descriptionController.text;

    // Example of updating the item locally (you may need to implement saving to a database)
    setState(() {
      widget.todo['title'] = updatedTitle;
      widget.todo['description'] = updatedDescription;
      widget.todo['items'] = _items; // Update checklist items if any
    });

    // Optionally, pop the page after updating
    Navigator.pop(context, {
      'id': widget.todo['id'],
      'title': updatedTitle,
      'description': updatedDescription,
      'items': _items,
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateTodo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            if (widget.todo['type'] == 'note')
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            if (widget.todo['type'] == 'checklist')
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
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
                          child: Text(
                            item['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            if (widget.todo['type'] == 'image')
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(
                  widget.todo['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
