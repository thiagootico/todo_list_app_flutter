import 'package:flutter/material.dart';
import 'task_model.dart'; // seu model

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo Corinthians',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        checkboxTheme: const CheckboxThemeData(
          fillColor: MaterialStatePropertyAll(Colors.red),
        ),
      ),
      home: const TaskListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Task> _tasks = [];

  @override
  Widget build(BuildContext context) {
    final tasksPendentes = _tasks.where((t) => !t.isDone).toList();
    final tasksConcluidas = _tasks.where((t) => t.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarefas a realizar"),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/pt/b/b4/Corinthians_simbolo.png',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: "Apagar todas",
            onPressed: () {
              if (_tasks.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Apagar todas as tarefas"),
                    content: const Text("Tem certeza que deseja apagar tudo?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _tasks.clear();
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          "Apagar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma tarefa ainda 🏟️",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                if (tasksPendentes.isNotEmpty) ...[
                  const Text(
                    "Pendentes ⚽",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...tasksPendentes.map((task) => _buildTaskCard(task)),
                  const SizedBox(height: 16),
                ],
                if (tasksConcluidas.isNotEmpty) ...[
                  const Text(
                    "Concluídas ✅",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...tasksConcluidas.map((task) => _buildTaskCard(task)),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
          if (newTask != null) {
            setState(() {
              _tasks.add(newTask);
            });
          }
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      color: task.isDone ? Colors.grey[200] : Colors.white,
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : Colors.black,
          ),
        ),
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) {
            setState(() {
              task.isDone = value ?? false;
            });
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              _tasks.remove(task);
            });
          },
        ),
      ),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Tarefa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Título da tarefa",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, Task(title: _controller.text));
                }
              },
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
