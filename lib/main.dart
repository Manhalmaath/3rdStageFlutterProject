import 'dart:convert';

import 'package:todo/database_helper.dart';

import 'task.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  List<Task> _tasks = [];
  late DatabaseHelper dbConnection;
  @override
  void initState() {
    super.initState();
    dbConnection = DatabaseHelper();
  }

  Future<List<Task>> loadData() {
    dbConnection.allNotes().then((value) {
      setState(() {
        _tasks = value;
      });
    });
    debugPrint('loadData');
    return Future.value(_tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
      ),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks yet'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Task task = snapshot.data![index];
                debugPrint('task ${task.title}');
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: ListTile(
                    onTap: (() => task.showCard(context)),
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
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              dbConnection.delete(1);
                              loadData();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check_rounded),
                          onPressed: () {
                            setState(() {
                              task.isDone = !task.isDone;
                              dbConnection.edit(task);
                              loadData();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
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
                          dbConnection.create(Task(
                              title: _textEditingController.text,
                              description: _descriptionEditingController.text,
                              isDone: false));
                        });
                        debugPrint('task created');
                        Navigator.of(context).pop();
                        loadData();
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
