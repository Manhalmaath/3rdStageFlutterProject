import 'dart:convert';

import 'task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ToDo App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Task> _tasks = [];
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();

  
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTasks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadTasks();
    } else if (state == AppLifecycleState.paused) {
      _saveTasks();
    }
  }

  void _saveTasks() async {
    // Serialize the list of tasks to a JSON string
    String tasksJson = json.encode(_tasks);

    // Get the instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the tasks JSON string in the local storage
    await prefs.setString('tasks', tasksJson);
  }

  void _loadTasks() async {
    // Get the instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load the tasks JSON string from the local storage
    String? tasksJson = prefs.getString('tasks');

    // Deserialize the tasks JSON string to a list of tasks
    List<Task> tasks = (tasksJson != null) ? json.decode(tasksJson).map((i) => Task.fromJson(i)).toList() : [];

    // Update the _tasks list with the loaded tasks
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          Task task = _tasks[index];
          return Card(
              margin: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: ListTile(
                onTap: () {
                  task.showCard(context);
                },
                title: Text(
                  task.title,
                  style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.check_rounded),
                      onPressed: () {
                        setState(() {
                          task.isDone = !task.isDone;
                        });
                      },
                    ),
                  ],
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                title: const Text('Add a new task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: _descriptionEditingController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (_textEditingController.text.isNotEmpty) {
                        setState(() {
                          _tasks.add(Task(
                              title: _textEditingController.text,
                              description: _descriptionEditingController.text));
                        });
                        Navigator.of(context).pop();
                        _textEditingController.clear();
                        _descriptionEditingController.clear();
                      }
                    },
                    child: Text('Create'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _textEditingController.clear();
                      _descriptionEditingController.clear();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
