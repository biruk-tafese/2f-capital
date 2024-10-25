import 'package:flutter/material.dart';
import 'package:todochatapp/features/todo/data/todos_data.dart';
import 'package:todochatapp/features/todo/presentation/category_section.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Organize todos by category
    final categories = _groupTodosByCategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Overview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to AddTodoPage (placeholder for the add button)
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.keys.length,
        itemBuilder: (context, index) {
          final category = categories.keys.elementAt(index);
          final categoryTodos = categories[category]!;

          return CategorySection(
            category: category,
            todos: categoryTodos,
          );
        },
      ),
    );
  }

  // Helper function to group todos by category
  Map<String, List<Map<String, dynamic>>> _groupTodosByCategory() {
    final Map<String, List<Map<String, dynamic>>> categories = {};

    for (var todo in todos) {
      if (!categories.containsKey(todo['category'])) {
        categories[todo['category']] = [];
      }
      categories[todo['category']]!.add(todo);
    }

    return categories;
  }
}
