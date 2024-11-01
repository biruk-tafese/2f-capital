import 'package:flutter/material.dart';
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/presentation/screens/auth/login_screen.dart';
import 'package:twof/presentation/screens/chat/chat_show_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final AuthService _authService = AuthService();

  Future<void> _logout() async {
    await _authService.signOut();
    // Navigate to the LoginScreen after logout
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2f Chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _logout, // Update to use the _logout method
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: const Center(
        child: ChatShowPage(),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
                _authService.getCurrentUser()?.email ?? 'Unknown User',
                style: const TextStyle(color: Colors.white)),
            accountEmail: Text(
                _authService.getCurrentUser()?.email ?? 'Unknown User',
                style: const TextStyle(color: Colors.white70)),
            currentAccountPicture: const Icon(
              Icons.account_circle,
              size: 50,
              color: Color.fromARGB(255, 129, 124, 124),
            ),
            otherAccountsPictures: const [],
          ),
          DrawerListTile(
            iconData: Icons.group,
            title: 'New Group',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.person_outline,
            title: 'Contacts',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.phone,
            title: 'Calls',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.place_outlined,
            title: 'People Nearby',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.bookmark_border,
            title: 'Saved Messages',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.settings,
            title: 'Settings',
            onTilePressed: () {},
          ),
          const Divider(),
          DrawerListTile(
            iconData: Icons.person_add,
            title: 'Invite Friends',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.help_outline,
            title: 'Telegram FAQ',
            onTilePressed: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTilePressed;

  const DrawerListTile({
    super.key,
    required this.iconData,
    required this.title,
    required this.onTilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTilePressed,
      dense: true,
      leading: Icon(iconData),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
