import 'package:todo/task.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  // static late Database _db;
  Future<Database> createDAtabase() async {
    final _db = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'notes.Db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'create table ToDo(ID integer primary key autoincrement,  title TEXT,description TEXT,isDone TEXT)',
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

  Future<List> allNotes() async {
    Database db = await createDAtabase();
    return db.query('ToDo');
  }

  Future<List> checkedNotes() async {
    Database db = await createDAtabase();
    return db.query('ToDo', where: 'isChecked=?', whereArgs: ['true']);
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
