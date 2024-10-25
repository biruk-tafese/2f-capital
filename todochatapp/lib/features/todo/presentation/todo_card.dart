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
          mainAxisSize: MainAxisSize.min, // Allows card to adapt to content
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
              Text(
                todo['description'],
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            else if (todo['type'] == 'checklist')
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100, // Limit height to avoid overflow
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: todo['items'].length,
                  itemBuilder: (context, index) {
                    final item = todo['items'][index];
                    return Row(
                      children: [
                        Checkbox(
                          value: item['done'],
                          onChanged: (bool? value) {},
                        ),
                        Expanded(
                          child: Text(
                            item['name'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            else if (todo['type'] == 'image')
              AspectRatio(
                aspectRatio: 1.5,
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
