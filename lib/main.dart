import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          buttonColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple, // Splash screen background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Task Tracker',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue], // Gradient for AppBar
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text('Task Tracker'),
            foregroundColor: Colors.white,
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove the shadow
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue], // Stylish gradient for body
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                  height:
                      24), // This creates a visible gap between AppBar and body
              // Add hover effect to the buttons using MouseRegion
              HoverButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddTaskScreen()));
                },
                child: const Text('Add Task'),
              ),
              const SizedBox(height: 20),
              HoverButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DisplayTasksScreen()));
                },
                child: const Text('Display Tasks'),
              ),
              const SizedBox(height: 20),
              HoverButton(
                onPressed: () {
                  // Navigate to Delete Tasks Screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeleteTasksScreen()));
                },
                child: const Text('Delete Tasks'),
              ),
              const SizedBox(height: 20),
              HoverButton(
                onPressed: () {
                  // Navigate to Update Tasks Screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpdateTasksScreen()));
                },
                child: const Text('Update Tasks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const HoverButton({required this.onPressed, required this.child, super.key});

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isHovered
              ? Colors.purpleAccent
              : Colors.white, // Color changes based on hover
          elevation: _isHovered ? 10 : 4, // Elevation changes on hover
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Rounded corners for modern look
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _isHovered
                ? Colors.white
                : Colors.deepPurple, // Change text color on hover
            // Text color changes to white when hovered
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                labelStyle: TextStyle(color: Colors.deepPurple[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.deepPurple[600]!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.deepPurple[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.deepPurple[600]!),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_dueDate == null
                    ? 'Select Due Date'
                    : 'Due Date: ${_dueDate!.toLocal()}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDueDate,
                  color: Colors.deepPurple[600],
                ),
              ],
            ),
            const SizedBox(height: 20),
            HoverButton(
              onPressed: _addTask,
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  Future<void> _addTask() async {
    if (_taskNameController.text.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields'),
      ));
      return;
    }

    try {
      await firestore.FirebaseFirestore.instance.collection('tasks').add({
        'taskName': _taskNameController.text,
        'description': _descriptionController.text,
        'dueDate': _dueDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task added successfully!'),
      ));
    } catch (e) {
      print("Error adding task: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add task. Please try again.'),
      ));
    }

    Navigator.pop(context);
  }
}

class DisplayTasksScreen extends StatefulWidget {
  const DisplayTasksScreen({super.key});

  @override
  _DisplayTasksScreenState createState() => _DisplayTasksScreenState();
}

class _DisplayTasksScreenState extends State<DisplayTasksScreen> {
  List<firestore.DocumentSnapshot> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    firestore.FirebaseFirestore.instance.collection('tasks').snapshots().listen(
      (snapshot) {
        setState(() {
          _tasks = snapshot.docs;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Display Tasks'),
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          )),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(
                task['taskName'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Due: ${task['dueDate'].toDate().toLocal()}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DeleteTasksScreen extends StatefulWidget {
  const DeleteTasksScreen({super.key});

  @override
  _DeleteTasksScreenState createState() => _DeleteTasksScreenState();
}

class _DeleteTasksScreenState extends State<DeleteTasksScreen> {
  List<firestore.DocumentSnapshot> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    firestore.FirebaseFirestore.instance.collection('tasks').snapshots().listen(
      (snapshot) {
        setState(() {
          _tasks = snapshot.docs;
        });
      },
    );
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await firestore.FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully!')),
      );
    } catch (e) {
      print("Error deleting task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to delete task. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Delete Tasks'),
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          )),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(task['taskName']),
              subtitle: Text('Due: ${task['dueDate'].toDate().toLocal()}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTask(task.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UpdateTasksScreen extends StatefulWidget {
  const UpdateTasksScreen({super.key});

  @override
  _UpdateTasksScreenState createState() => _UpdateTasksScreenState();
}

class _UpdateTasksScreenState extends State<UpdateTasksScreen> {
  List<firestore.DocumentSnapshot> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    firestore.FirebaseFirestore.instance.collection('tasks').snapshots().listen(
      (snapshot) {
        setState(() {
          _tasks = snapshot.docs;
        });
      },
    );
  }

  void _navigateToEditTaskScreen(firestore.DocumentSnapshot task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Update Tasks'),
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          )),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(task['taskName']),
              subtitle: Text('Due: ${task['dueDate'].toDate().toLocal()}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _navigateToEditTaskScreen(task),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final firestore.DocumentSnapshot task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskNameController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.task['taskName']);
    _descriptionController =
        TextEditingController(text: widget.task['description']);
    _dueDate = widget.task['dueDate'].toDate();
  }

  Future<void> _updateTask() async {
    if (_taskNameController.text.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields'),
      ));
      return;
    }

    try {
      await firestore.FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.task.id)
          .update({
        'taskName': _taskNameController.text,
        'description': _descriptionController.text,
        'dueDate': _dueDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error updating task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update task. Please try again.')),
      );
    }
  }

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Task'),
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_dueDate == null
                    ? 'Select Due Date'
                    : 'Due Date: ${_dueDate!.toLocal()}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDueDate,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
