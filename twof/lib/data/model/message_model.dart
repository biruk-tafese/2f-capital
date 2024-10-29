class Message {
  String id;
  String senderId;
  String content;
  String type; // text, image, audio
  int timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'type': type,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      senderId: map['senderId'],
      content: map['content'],
      type: map['type'],
      timestamp: map['timestamp'],
    );
  }
}
