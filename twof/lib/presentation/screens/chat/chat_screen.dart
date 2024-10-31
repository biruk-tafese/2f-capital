import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String email;

  const ChatScreen(
      {super.key,
      required this.chatId,
      required this.currentUserId,
      required this.email});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any, // Allows picking any type of file
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      // Here you can upload the file to your storage and store the file reference in Firestore
      _sendFileMessage(file.name, file.path);
    }
  }

  Future<void> _sendFileMessage(String fileName, String? filePath) async {
    if (filePath != null) {
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'fileName': fileName,
          'filePath': filePath, // Store path or upload URL if uploaded
          'timestamp': FieldValue.serverTimestamp(),
          'chatId': widget.chatId,
          'senderId': widget.currentUserId,
          'type':
              'file', // Use 'type' to differentiate file messages from text messages
        });
      } catch (e) {
        print('Error sending file: $e');
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to send message. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.email}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chatId', isEqualTo: widget.chatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs
                    .map((doc) => doc.data())
                    .toList()
                    .cast<Map<String, dynamic>>();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender =
                        message['senderId'] == widget.currentUserId;
                    final isFile = message['type'] == 'file';

                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isFile)
                              Text(
                                'File: ${message['fileName']}',
                                style: TextStyle(
                                  color: isSender ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              Text(
                                message['text'],
                                style: TextStyle(
                                  color: isSender ? Colors.white : Colors.black,
                                ),
                              ),
                            SizedBox(height: 5),
                            Text(
                              message['timestamp'] != null
                                  ? message['timestamp'].toDate().toString()
                                  : 'Sending...',
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    isSender ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickFile, // Call _pickFile to select a file
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'chatId': widget.chatId,
          'senderId': widget.currentUserId,
          'type': 'text', // Differentiate text messages
        });
        _textEditingController.clear();
      } catch (e) {
        print('Error sending message: $e');
        _showErrorDialog();
      }
    }
  }
}
