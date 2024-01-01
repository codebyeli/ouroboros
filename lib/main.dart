import 'package:flutter/material.dart';
import 'splash.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: splashscreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    leading: Image.asset('assets/miniourosicon.png'),
    title: Text(
    "Ouroboros"
    ),
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
              child: Text("Welcome!",
                style: TextStyle(fontSize: 40),),
            ),
          ],
        ),
        if (tasks.isEmpty == false)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('These are your tasks for today:')
            ],
          ),
        ),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Wow, you have no tasks for today!')
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
    onPressed: () {},
    child: Icon(Icons.add),
                foregroundColor: Colors.white,
    backgroundColor: Colors.black,
              )
    );
  }
}

