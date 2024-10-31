class Message {
  String id;
  String email; // Assuming you'll use this for displaying the user's email
  String content;
  String time;
  bool isGroup;
  String senderId;
  int timestamp;

  Message({
    required this.id,
    required this.email,
    required this.time,
    required this.isGroup,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'content': content,
      'time': time,
      'isGroup': isGroup,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      email: map['email'],
      content: map['content'],
      time: map['time'],
      isGroup: map['isGroup'],
      senderId: map['senderId'],
      timestamp: map['timestamp'],
    );
  }
}
