import 'package:flutter/material.dart';
import 'package:todochatapp/features/todo/data/firebase_db.dart';
import 'package:todochatapp/features/todo/model/todo_model.dart';
import 'package:todochatapp/features/todo/presentation/add_todo_page.dart';
import 'package:todochatapp/features/todo/presentation/todo_card.dart';

class TodosPage extends StatefulWidget {
  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  bool isGridView = true; // Toggle for view
  List<Map<String, dynamic>> todos = [];
  final Stream<List<TodoModel>> collectionReference = FirebaseDB.readTodo();
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  void fetchTodos() {
    collectionReference.listen((event) {
      // Assuming event is a List<TodoModel> from Firebase
      setState(() {
        todos = event.map((todo) {
          return {
            'title': todo.title,
            'description': todo.description,
            'color': todo.color.value, // Convert color to integer
            'isPinned': todo.isPinned ?? false,
          };
        }).toList();

        // Sort pinned todos to the top
        todos.sort((a, b) => b['isPinned'] ? 1 : 0);
        isLoading = false; // Stop loading once data is fetched
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodoPage()),
              );
            },
            icon: Icon(Icons.add), // Add button
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView; // Toggle view
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : todos.isEmpty
              ? Center(child: Text("No todos available")) // No todos message
              : isGridView
                  ? buildGridView()
                  : buildListView(),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoCard(todo: todos[index]);
      },
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoCard(todo: todos[index]);
      },
    );
  }
}
