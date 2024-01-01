import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.black, // Set the primary color to black
    ),
    home: OurosHome(),
  ));
}

class OurosHome extends StatefulWidget {
  const OurosHome({Key? key}) : super(key: key);

  @override
  State<OurosHome> createState() => _OurosHomeState();
}

class Task {
  int? id;
  String name;
  bool isCompleted;
  bool isCycle;

  Task({
    this.id,
    required this.name,
    required this.isCompleted,
    required this.isCycle,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted ? 1 : 0,
      'isCycle': isCycle ? 1 : 0,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    Database db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  Future<void> deleteTask(int taskId) async {
    Database db = await instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        isCompleted INTEGER,
        isCycle INTEGER
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        name: maps[i]['name'],
        isCompleted: maps[i]['isCompleted'] == 1,
        isCycle: maps[i]['isCycle'] == 1,
      );
    });
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController _nameController;
  bool _isCompleted = false;
  bool _isCycle = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Set the border color when focused
                  ),
                ),
                style: TextStyle(color: Colors.black), // Set the text color
                cursorColor: Colors.black, // Set the cursor color
                autofocus: true,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isCycle,
                    activeColor: Colors.black,
                    onChanged: (value) {
                      setState(() {
                        _isCycle = value!;
                      });
                    },
                  ),
                  Text('Daily Task'),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  Task newTask = Task(
                    name: _nameController.text,
                    isCompleted: _isCompleted,
                    isCycle: _isCycle,
                  );

                  // Add the task to the database
                  await DatabaseHelper.instance.insertTask(newTask);

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Clear the text field and reset checkboxes
                  _nameController.clear();
                  setState(() {
                    _isCompleted = false;
                    _isCycle = false;
                  });

                  // Refresh the task list after adding a new task
                  _OurosHomeState()._loadTasks();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Add Task',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

class _OurosHomeState extends State<OurosHome> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _deleteTask(int taskId) async {
    await DatabaseHelper.instance.deleteTask(taskId);
    _loadTasks(); // Reload tasks after deletion
  }

  Future<void> _loadTasks() async {
    tasks = await DatabaseHelper.instance.getTasks();
    setState(() {});
  }

  Future<void> _addTask(Task task) async {
    await DatabaseHelper.instance.insertTask(task);
    _loadTasks();
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog();
      },
    );

    // Refresh the task list after adding a new task
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/miniourosicon.png'),
        title: Text("Ouroboros"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Text(
                  "Welcome!",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ],
          ),
          if (tasks.isEmpty == false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('These are your tasks for today:'),
                ],
              ),
            ),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Wow, you have no tasks for today!'),
                ],
              ),
            ),
          for (Task task in tasks)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          setState(() {
                            task.isCompleted = newValue;
                          });
                        }
                      },
                    ),
                    Text(task.name),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        // Add logic to edit task
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteTask(task.id!); // Assuming task.id is non-null
                      },
                      icon: Icon(Icons.delete, size: 25),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
  }
}
