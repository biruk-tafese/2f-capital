import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todochatapp/features/auth/presentation/login_page.dart';
import 'package:todochatapp/features/chat/chat_page.dart';
import 'package:todochatapp/features/global/common/toast.dart';
import 'package:todochatapp/features/todo/presentation/todos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final screen = [
    TodosPage(),
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two F Capital'),
        actions: [
          const Icon(Icons.person),
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
                showToast(message: "Signed out successfully");
              } catch (error) {
                // Handle error
                showToast(message: "Error signing out: $error");
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Center(
          child: screen[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'Chat',
          )
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
