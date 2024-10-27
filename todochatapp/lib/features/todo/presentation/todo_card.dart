import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo['color'] ?? Colors.blue, // Default color
      child: ListTile(
        title: Text(todo['title']),
        subtitle: Text(todo['description'] ?? ''),
        trailing: IconButton(
          icon: Icon(
            todo['isPinned'] ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () {
            // Update pin status in Firebase
            final DatabaseReference todoRef =
                FirebaseDatabase.instance.ref('todos/${todo['id']}');
            todoRef.update({'isPinned': !todo['isPinned']});
          },
        ),
      ),
    );
  }
}
