import 'package:flutter/material.dart';
import 'package:todochatapp/features/todo/data/todos_data.dart';
import 'package:todochatapp/features/todo/presentation/add_todo_page.dart';
import 'package:todochatapp/features/todo/presentation/todo_card.dart';
import 'package:todochatapp/features/todo/presentation/todos_detail_page.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = _groupTodosByCategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Overview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddTodoPage();
              }));
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: categories.keys.length,
        itemBuilder: (context, index) {
          final category = categories.keys.elementAt(index);
          final categoryTodos = categories[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1,
                ),
                itemCount: categoryTodos.length,
                itemBuilder: (context, gridIndex) {
                  return GestureDetector(
                    // Wrap TodoCard in GestureDetector
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TodoDetailPage(todo: categoryTodos[gridIndex]),
                        ),
                      );
                    },
                    child: TodoCard(todo: categoryTodos[gridIndex]),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

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
