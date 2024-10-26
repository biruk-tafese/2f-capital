import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todochatapp/features/todo/data/firebase_db.dart';
import 'package:todochatapp/features/todo/model/todo_model.dart';

class TodoCard extends StatefulWidget {
  final Map<String, dynamic> todo;
  const TodoCard({super.key, required this.todo});

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late Map<String, dynamic> todo;
  final Stream<List<TodoModel>> collectionReference = FirebaseDB.readTodo();

  @override
  void initState() {
    super.initState();
    todo = widget.todo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<TodoModel>>(
        stream: collectionReference,
        builder:
            (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.map((todo) {
              return Card(
                color: Color(todo.color.value), // Default color if not set
                child: ListTile(
                  title: Text(todo.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todo.description ?? ''),
                      Text("Category: ${todo.category}"), // Show category
                      Text("Type: ${todo.type}"), // Show type
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      todo.isPinned ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      // Update pin status in Firebase
                      final DatabaseReference todoRef =
                          FirebaseDatabase.instance.ref('todos/${todo.id}');
                      todoRef.update({'isPinned': !todo.isPinned});
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
