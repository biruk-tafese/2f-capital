import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todochatapp/features/todo/data/firebase_db.dart';
import 'package:todochatapp/features/todo/data/model/todo_model.dart';
import 'package:todochatapp/features/todo/presentation/add_todo_page.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodosPage> {
  bool isGridView = false; // Toggle to switch views
  FirebaseDB firebaseDB = FirebaseDB();
  late DatabaseReference _dbRef;
  late Stream<DatabaseEvent> todosStream;

  @override
  void initState() {
    super.initState();
    _dbRef =
        FirebaseDatabase.instance.ref('todos'); // Reference to the todos node
    todosStream =
        _dbRef.onValue; // Set up the stream to listen for value changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTodoPage()));
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: todosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Get the list of todos from the snapshot
          final todosData = (snapshot.data?.snapshot.value ?? {}) as Map;
          final todosList = todosData.entries.map((entry) {
            final todo = entry.value;
            return ListTile(
              title: Text(todo['title'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo['description'] ?? ''),
                  if (todo['lastEditedBy'] != null) // Show last edited user
                    Text('Last edited by: ${todo['lastEditedBy']}'),
                  if (todo['lastEditedAt'] !=
                      null) // Show last edited timestamp
                    Text('Last edited at: ${todo['lastEditedAt']}'),
                ],
              ),
              tileColor: Color(todo['color'] ?? 0xFFFFFFFF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddTodoPage(todo: TodoModel.fromMap(todo)),
                  ),
                );
              },
            );
          }).toList();

          return ListView(children: todosList); // Display the todos
        },
      ),
    );
  }
}
