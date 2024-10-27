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
      body: StreamBuilder<List<TodoModel>>(
        stream: firebaseDB.readTodo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No todos available."));
          }

          final todos = snapshot.data!;

          return isGridView
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return TodoItemCard(todo: todos[index]);
                  },
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return TodoItemCard(todo: todos[index]);
                  },
                );
        },
      ),
    );
  }
}

class TodoItemCard extends StatelessWidget {
  final TodoModel todo;

  const TodoItemCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(todo.color.value), // Fallback to white if color is null
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title ?? "No Title", // Fallback if title is null
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(todo.description ?? "No Description"),
            if (todo.type != null) // Show type if not null
              Text("Type: ${todo.type}"),
            if (todo.category != null) // Show category if not null
              Text("Category: ${todo.category}"),
            if (todo.lastEdited != null) // Show last edited user if not null
              Text("Last edited by: ${todo.lastEdited}"),
            if (todo.lastEdited !=
                null) // Show last edited timestamp if not null
              Text("Last edited at: ${todo.lastEdited}"),
            SizedBox(height: 4),
            if (todo.imageUrl != null) // Show image if URL is not null
              Image.network(todo.imageUrl!, height: 50, fit: BoxFit.cover),
            if (todo.isPinned) // Show pin icon if pinned
              Icon(Icons.push_pin, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
