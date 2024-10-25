import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo['color'],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Allows the card to resize based on content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            if (todo['type'] == 'note')
              Flexible(
                child: Text(
                  todo['description'],
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else if (todo['type'] == 'checklist')
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in todo['items'])
                      Row(
                        children: [
                          Checkbox(
                            value: item['done'],
                            onChanged: (bool? value) {},
                          ),
                          Flexible(
                            // Ensures each item fits within available space
                            child: Text(
                              item['name'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            else if (todo['type'] == 'image')
              Flexible(
                child: Image.network(
                  todo['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
