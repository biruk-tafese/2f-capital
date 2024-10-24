import 'package:flutter/material.dart';
import 'package:todochatapp/features/todo/data/todos_data.dart';
import 'package:todochatapp/features/todo/presentation/add_todo_page.dart';
import 'package:todochatapp/features/todo/presentation/todo_card.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Todos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTodoPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1, // Adjust this if needed
        ),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return TodoCard(todo: todo);
        },
      ),
    );
  }
}
