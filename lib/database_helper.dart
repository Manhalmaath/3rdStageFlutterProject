import 'package:todo/task.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  // static late Database _db;
  Future<Database> createDatabase() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'Tasks.Db'),
      onCreate: (db, version) {
        return db.execute(
          '''create table ToDo(ID integer primary key autoincrement,
            title TEXT,
            description TEXT,
            isDone TEXT)''',
        );
      },

      version: 1,
    );

    return db;
  }

  Future<int> create(Task model) async {
    Database db = await createDatabase();
    return db.insert(
      'ToDo',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getAllTasks() async {
    Database db = await createDatabase();
    return db.query('ToDo');
  }

  Future<int> delete(int id) async {
    Database db = await createDatabase();
    return db.delete('ToDo', where: 'ID=?', whereArgs: [id]);
  }

  Future<int> update(Task model) async {
    Database db = await createDatabase();
    return await db
        .update('ToDo', model.toMap(), where: 'ID = ?', whereArgs: [model.id]);
  }
}
