class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  String createdBy;
  Map<String, bool> collaborators;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdBy,
    required this.collaborators,
  });

  // Convert a Todo object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdBy': createdBy,
      'collaborators': collaborators,
    };
  }

  // Create a Todo object from a Firebase snapshot
  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      createdBy: map['createdBy'],
      collaborators: Map<String, bool>.from(map['collaborators'] ?? {}),
    );
  }
}
