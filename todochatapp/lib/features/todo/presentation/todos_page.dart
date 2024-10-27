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
        stream: FirebaseDB.readTodo(),
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

  TodoItemCard({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo.color,
      child: ListTile(
        title: Text(todo.title),
        subtitle: Text(todo.description ?? ""),
        trailing:
            todo.isPinned ? Icon(Icons.push_pin, color: Colors.red) : null,
      ),
    );
  }
}
