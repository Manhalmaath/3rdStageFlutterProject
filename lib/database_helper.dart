import 'package:flutter/material.dart';
import 'package:todo/task.dart';

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();
  // static late Database _db;
  Future<Database> createDAtabase() async {
    final _db = openDatabase(
      join(await getDatabasesPath(), 'Tasks.Db'),
      onCreate: (db, version) {
        return db.execute(
          '''create table ToDo(ID integer primary key autoincrement,
            title TEXT,
            description TEXT,
            is_done TEXT)''',
        );
      },
      version: 1,
    );
    return _db;
  }

  Future<int> create(Task model) async {
    Database db = await createDAtabase();
    return db.insert(
      'ToDo',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> allNotes() async {
    Database db = await createDAtabase();
    final List<Map<String, dynamic>> maps = await db.query('ToDo');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['ID'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        isDone: maps[i]['isDone'],
      );
    });
  }

  Future<int> delete(int id) async {
    Database db = await createDAtabase();
    return db.delete('ToDo', where: 'ID=?', whereArgs: [id]);
  }

  Future<int> edit(Task model) async {
    Database db = await createDAtabase();
    return await db
        .update('ToDo', model.toMap(), where: 'ID = ?', whereArgs: [model.id]);
  }

  Future<int> editCheck(Task model) async {
    Database db = await createDAtabase();
    return await db
        .update('ToDo', model.toMap(), where: 'ID = ?', whereArgs: [model.id]);
  }
}












// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import 'database_helper.dart';

// import 'package:todo/task.dart';










/*
class DatabaseConnection {
  static const _databaseName = 'tasks.db';
  static const _databaseVersion = 1;

  static const table = 'tasks';

  static const columnId = '_id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnIsDone = 'is_done';

  static Database? _database;






  Future<Database?> get database async {

    if (_database != null) return _database;
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {


    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnDescription TEXT NOT NULL,
      $columnIsDone INTEGER NOT NULL
    )
    ''');
  }

  Future<Task> insert(Task tasks) async {
    var db = await database;
    await db!.insert(table, tasks.toMap());
    return tasks;
  }

  Future<List<Task>> getTasks() async {
    var db = await database;
    var result = await db!.query(table);
    debugPrint('this is get task method');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> update(Task task) async {
    var db = await database;
    return await db!.update(table, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.id]);
  }

  Future<int> delete(int id) async {
    var db = await database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
*/