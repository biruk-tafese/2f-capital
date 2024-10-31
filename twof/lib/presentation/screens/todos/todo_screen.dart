import 'package:flutter/material.dart';
import 'package:twof/core/services/auth_services.dart';
import 'package:twof/core/services/todo_service.dart';
import 'package:twof/data/model/todo_model.dart';
import 'package:twof/presentation/screens/auth/login_screen.dart';
import 'package:twof/presentation/screens/todos/add_todo_screen.dart';
import 'package:twof/presentation/screens/todos/todo_detail_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool isGridView = true;
  final TextEditingController _searchController = TextEditingController();
  List<Todo> todos = [];
  List<Todo> filteredTodos = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTodos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTodos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTodos = todos.where((todo) {
        return todo.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TodoService todoService = TodoService();
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search your notes',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await authService.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout_rounded)),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading todos'));
          }

          todos = snapshot.data ?? [];
          // If search is active, display filtered results; otherwise, display all todos
          final displayedTodos =
              _searchController.text.isNotEmpty ? filteredTodos : todos;
          final pinnedTodos =
              displayedTodos.where((todo) => todo.isPinned).toList();
          final regularTodos =
              displayedTodos.where((todo) => !todo.isPinned).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                if (pinnedTodos.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('PINNED',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  _buildTodoGrid(pinnedTodos),
                ],
                _buildTodoGrid(regularTodos),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTodoScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoGrid(List<Todo> todos) {
    final pinnedTodos = todos.where((todo) => todo.isPinned).toList();
    final unpinnedTodos = todos.where((todo) => !todo.isPinned).toList();

    if (isGridView) {
      return Column(
        children: [
          if (pinnedTodos.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: pinnedTodos
                    .map((todo) => Container(
                          width: 150,
                          margin: const EdgeInsets.all(8),
                          child: _buildTodoCard(todo),
                        ))
                    .toList(),
              ),
            ),
          if (pinnedTodos.isNotEmpty) const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: unpinnedTodos.length,
            itemBuilder: (context, index) {
              return _buildTodoCard(unpinnedTodos[index]);
            },
          ),
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return _buildTodoCard(todo);
        },
      );
    }
  }

  Widget _buildTodoCard(Todo todo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoDetailScreen(todo: todo),
          ),
        );
      },
      child: Card(
        color: todo.isPinned ? Colors.yellow[100] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title ?? 'Untitled',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                todo.description ?? 'No description',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
