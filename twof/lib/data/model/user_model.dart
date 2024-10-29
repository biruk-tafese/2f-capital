class UserPresence {
  String userId;
  bool isOnline;
  int lastSeen;

  UserPresence({
    required this.userId,
    required this.isOnline,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }

  factory UserPresence.fromMap(String userId, Map<String, dynamic> map) {
    return UserPresence(
      userId: userId,
      isOnline: map['isOnline'],
      lastSeen: map['lastSeen'],
    );
  }
}
