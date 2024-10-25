import 'package:flutter/material.dart';
import 'package:todochatapp/features/todo/presentation/todo_card.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> todos;

  const CategorySection(
      {super.key, required this.category, required this.todos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 3 / 2,
            ),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoCard(todo: todo);
            },
          ),
        ),
      ],
    );
  }
}
