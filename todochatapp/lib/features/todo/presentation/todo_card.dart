import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo['color'], // Custom color for each todo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Makes the card's height flexible
          children: [
            Text(
              todo['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis, // Prevents overflow
            ),
            const SizedBox(height: 5),
            if (todo['type'] == 'note')
              Text(
                todo['description'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                maxLines: 3, // Limits lines to avoid overflow
                overflow: TextOverflow.ellipsis,
              )
            else if (todo['type'] == 'image')
              Flexible(
                child: Column(
                  children: [
                    Text(todo['title']),
                    const SizedBox(height: 5),
                    Image.network(
                      todo['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              )
            else if (todo['type'] == 'checklist')
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Expanded(
                      // Use ListView to make the list of items scrollable if needed
                      child: ListView.builder(
                        itemCount: todo['items'].length,
                        itemBuilder: (context, index) {
                          final item = todo['items'][index];
                          return Row(
                            children: [
                              Flexible(
                                child: Checkbox(
                                  value: item['done'],
                                  onChanged: (bool? value) {
                                    // Update the item's status
                                    item['done'] = value!;
                                  },
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  item['name'],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
