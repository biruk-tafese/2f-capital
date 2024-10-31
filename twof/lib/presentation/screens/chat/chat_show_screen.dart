import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/core/services/chat_service.dart';
import 'package:twof/data/model/message_model.dart';
import 'package:twof/presentation/screens/chat/chat_screen.dart';

class ChatShowPage extends StatefulWidget {
  const ChatShowPage({super.key});

  @override
  _ChatShowPageState createState() => _ChatShowPageState();
}

class _ChatShowPageState extends State<ChatShowPage> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  List<Message> messages = []; // To store fetched messages
  List<Message> filteredMessages = []; // To store filtered messages

  bool isSearching = false; // Track if search mode is active
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserEmails();
    _searchController.addListener(_filterMessages);
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller when not in use
    super.dispose();
  }

  String formatTime(DateTime dateTime) {
    // Using 24-hour format with seconds
    //return DateFormat("HH:mm:ss").format(dateTime); // Example output: 14:30:15

    // Uncomment one of these options to use different formats:

    // Using 12-hour format with AM/PM
    return DateFormat("hh:mm a").format(dateTime); // Example output: 02:30 PM

    // Using 12-hour format with seconds and AM/PM
    // return DateFormat("hh:mm:ss a").format(dateTime); // Example output: 02:30:15 PM
  }

  Future<void> _fetchUserEmails() async {
    try {
      final userEmails = await _authService.fetchUserEmails();
      setState(() {
        messages = userEmails.map((email) {
          return Message(
            id: email, // Use
            email: email,
            time: formatTime(DateTime.now()), // Placeholder for time
            isGroup: false, // Set based on your logic
            senderId: _authService
                .getCurrentUser()!
                .uid, // Placeholder or logic to get sender ID
            content: "Last seen", // Placeholder content
            timestamp: DateTime.now().millisecondsSinceEpoch,
          );
        }).toList();
        filteredMessages = messages; // Initially display all messages
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user emails: $e")));
    }
  }

  void _filterMessages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredMessages = messages.where((message) {
        return message.email.toLowerCase().contains(query) ||
            message.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search chats...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              )
            : const Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  // Clear search and exit search mode
                  _searchController.clear();
                  filteredMessages = messages; // Show all messages
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: filteredMessages.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final message = filteredMessages[index];
          return ListTile(
            leading: Icon(
              message.isGroup ? Icons.group : Icons.person,
              size: 40,
              color: Colors.blue,
            ),
            title: Text(
              message.email, // Display the email as the chat name
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              message.content, // Display the last message
              style: const TextStyle(color: Colors.grey),
            ),
            trailing:
                Text(message.time), // Display the time of the last message
            onTap: () {
              // Navigate to the ChatScreen, passing the chatId (email)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      chatId: message.id,
                      currentUserId: AuthService()
                          .getCurrentUser()!
                          .uid, // i used sender id as email
                      email: message.email),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
