class UserModel {
  String id; // Unique user identifier (Firebase UID)
  String username;
  String email;
  String? avatarUrl;
  int? lastActive;
  List<String>? assignedTodos;

  // Constructor
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.lastActive,
    this.assignedTodos,
  });

  // Factory method to create a UserModel instance from a Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      avatarUrl: data['avatarUrl'],
      lastActive: data['lastActive'],
      assignedTodos: data['assignedTodos'] != null
          ? List<String>.from(data['assignedTodos'])
          : null,
    );
  }

  // Method to convert a UserModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'lastActive': lastActive,
      'assignedTodos': assignedTodos,
    };
  }
}
