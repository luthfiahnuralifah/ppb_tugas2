import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinky Todo List',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: TodoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Todo {
  final int id;
  final String text;
  final bool isCompleted;
  final Priority priority;
  final String category;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false,
    this.priority = Priority.medium,
    this.category = 'Pribadi',
  });
}

enum Priority { low, medium, high }

enum FilterType { all, pending, completed }

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [
    Todo(id: 1, text: 'Olahraga Pagi 🏃‍♀', priority: Priority.high),
    Todo(id: 2, text: 'Baca Buku 📖', priority: Priority.medium),
    Todo(id: 3, text: 'Masak Menu Baru 🍳', priority: Priority.low),
    Todo(
      id: 4,
      text: 'Quality Time bareng Keluarga 👨‍👩‍👧‍👦',
      priority: Priority.high,
    ),
    Todo(
      id: 5,
      text: 'Ngonten untuk Media Sosial 🎥',
      priority: Priority.medium,
    ),
    Todo(id: 6, text: 'Meditasi & Me Time 🧘‍♀', isCompleted: true),
    Todo(id: 7, text: 'Bersih-bersih Kamar 🧹', priority: Priority.low),
  ];

  FilterType currentFilter = FilterType.all;
  final TextEditingController textController = TextEditingController();

  void toggleTodo(int id) {
    setState(() {
      todos = todos.map((todo) {
        if (todo.id == id) {
          return Todo(
            id: todo.id,
            text: todo.text,
            isCompleted: !todo.isCompleted,
            priority: todo.priority,
            category: todo.category,
          );
        }
        return todo;
      }).toList();
    });
  }

  void addTodo() {
    if (textController.text.isNotEmpty) {
      setState(() {
        todos.add(
          Todo(
            id: DateTime.now().millisecondsSinceEpoch,
            text: textController.text,
            priority: Priority.low,
          ),
        );
        textController.clear();
      });
    }
  }

  void deleteTodo(int id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
  }

  List<Todo> getFilteredTodos() {
    switch (currentFilter) {
      case FilterType.completed:
        return todos.where((todo) => todo.isCompleted).toList();
      case FilterType.pending:
        return todos.where((todo) => !todo.isCompleted).toList();
      default:
        return todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Todo> filteredTodos = getFilteredTodos();
    int totalTodos = todos.length;
    int completedTodos = todos.where((todo) => todo.isCompleted).length;
    int pendingTodos = todos.where((todo) => !todo.isCompleted).length;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🌸 To-Do List 🌸",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Luthfiah Nur Alifah - 2309106102",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      buildStatCard(totalTodos, "Total", Colors.pink),
                      buildStatCard(completedTodos, "Selesai", Colors.green),
                      buildStatCard(pendingTodos, "Pending", Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      buildFilterButton("Semua", FilterType.all),
                      buildFilterButton("Belum Selesai", FilterType.pending),
                      buildFilterButton("Selesai", FilterType.completed),
                    ],
                  ),
                ],
              ),
            ),

            // Input tambah tugas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: "Tambah aktivitas baru...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.pinkAccent,
                      size: 32,
                    ),
                    onPressed: addTodo,
                  ),
                ],
              ),
            ),

            // List Tugas
            Expanded(
              child: filteredTodos.isEmpty
                  ? const Center(child: Text("Belum ada aktivitas 😴"))
                  : ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        return buildTodoItem(filteredTodos[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatCard(int value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget buildFilterButton(String label, FilterType filterType) {
    bool isSelected = currentFilter == filterType;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentFilter = filterType;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.pinkAccent : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pinkAccent),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.pinkAccent,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTodoItem(Todo todo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: todo.isCompleted ? Colors.pink.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => toggleTodo(todo.id),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: todo.isCompleted ? Colors.pinkAccent : Colors.transparent,
                border: Border.all(color: Colors.pinkAccent, width: 2),
              ),
              child: todo.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              todo.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null,
                color: todo.isCompleted ? Colors.grey : Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => deleteTodo(todo.id),
            child: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
