import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:twof/core/services/chat_service.dart';
import 'package:twof/data/model/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Message> _allMessages = []; // Original list of messages
  List<Message> _filteredMessages = []; // Filtered list based on search

  @override
  void initState() {
    super.initState();
    _chatService.getMessages(widget.chatId).listen((messages) {
      setState(() {
        _allMessages = messages;
        _filteredMessages = messages; // Initialize with all messages
      });
    });
  }

  void _filterMessages(String query) {
    final filtered = _allMessages.where((message) {
      return message.content.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredMessages = filtered;
    });
  }

  void _sendMessage() {
    final message = Message(
      id: '',
      senderId: 'userId', // Replace with current user's ID
      content: _messageController.text,
      type: 'text',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _chatService.sendMessage(widget.chatId, message);
    _messageController.clear();
  }

  Future<void> sendImageMessage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chatImages/${DateTime.now()}.jpg');
    await storageRef.putFile(image);
    final imageUrl = await storageRef.getDownloadURL();

    final message = Message(
      id: '',
      senderId: 'userId',
      content: imageUrl,
      type: 'image',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _chatService.sendMessage(widget.chatId, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterMessages,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMessages.length,
              itemBuilder: (context, index) {
                final message = _filteredMessages[index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(message.timestamp.toString()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
