import 'package:firebase_database/firebase_database.dart';
import 'package:twof/data/model/message_model.dart';
import 'package:twof/data/model/user_model.dart';

class ChatService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Sanitize user ID
  String sanitizeUserId(String userId) {
    return userId.replaceAll('.', '_'); // Replace '.' with '_'
  }

  // Sanitize the chat ID
  String sanitizeChatId(String chatId) {
    return chatId.replaceAll('.', '_'); // Replace '.' with '_'
  }

  // Send a message
  Future<void> sendMessage(String chatId, Message message) async {
    final sanitizedChatId = sanitizeChatId(chatId);
    final messageRef = _dbRef.child('chats/$sanitizedChatId/messages').push();
    await messageRef.set(message.toMap());
  }

  // Listen to messages in a chat
  Stream<List<Message>> getMessages(String chatId) {
    final sanitizedChatId = sanitizeChatId(chatId);
    return _dbRef.child('chats/$sanitizedChatId/messages').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.entries
            .map((e) =>
                Message.fromMap(e.key, Map<String, dynamic>.from(e.value)))
            .toList();
      } else {
        return [];
      }
    });
  }

  // Update user presence
  Future<void> updateUserPresence(String userId, bool isOnline) async {
    final sanitizedUserId = sanitizeUserId(userId);
    final userRef = _dbRef.child('users/$sanitizedUserId');
    await userRef.update({
      'isOnline': isOnline,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Get user presence
  Stream<UserPresence> getUserPresence(String userId) {
    final sanitizedUserId = sanitizeUserId(userId);
    return _dbRef.child('users/$sanitizedUserId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      return UserPresence.fromMap(
          sanitizedUserId, Map<String, dynamic>.from(data ?? {}));
    });
  }

  String generateOneOnOneChatId(String userId1, String userId2) {
    final sanitizedUserId1 = sanitizeUserId(userId1);
    final sanitizedUserId2 = sanitizeUserId(userId2);
    // Sort IDs to keep consistency in the chatId
    final sortedIds = [sanitizedUserId1, sanitizedUserId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}'; // e.g., "userA_userB"
  }

  // Create a one-on-one chat
  Future<void> createOneOnOneChat(String userId1, String userId2) async {
    final chatId = generateOneOnOneChatId(userId1, userId2);
    final chatRef = _dbRef.child('chats/$chatId');
    await chatRef.set({
      'members': [sanitizeUserId(userId1), sanitizeUserId(userId2)],
      'type': 'oneOnOne',
    });
  }

  String generateGroupChatId() {
    final groupChatRef = FirebaseDatabase.instance.ref().child('chats').push();
    return groupChatRef.key!; // This provides a unique key for the group chat
  }

  // Create a group chat
  Future<void> createGroupChat(String chatName, List<String> memberIds) async {
    final chatId = generateGroupChatId();
    final chatRef = _dbRef.child('chats/$chatId');
    await chatRef.set({
      'members': memberIds.map(sanitizeUserId).toList(),
      'type': 'group',
      'name': chatName,
    });
  }
}
