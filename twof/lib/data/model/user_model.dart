class UserPresence {
  String email;
  String userId;
  bool isOnline;
  int lastSeen;

  UserPresence({
    required this.userId,
    required this.isOnline,
    required this.lastSeen,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'email': email,
    };
  }

  factory UserPresence.fromMap(String userId, Map<String, dynamic> map) {
    return UserPresence(
      userId: userId,
      isOnline: map['isOnline'],
      lastSeen: map['lastSeen'],
      email: map['email'],
    );
  }
}
