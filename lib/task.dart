import 'package:flutter/material.dart';

class Task {
  late int? id;
  late String title;
  late String description;
  late String? isDone;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.isDone});

  Task.fromMap(Map data) {
    id = data['ID'];
    title = data['title'];
    description = data['description'];
    isDone = data['isDone'];
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
      'description': description,
      'isDone': isDone
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'toDO{id: $id, title: $title,description:$description,isDone:$isDone}';
  }

  get ID => id;

  get descriptionOfTheNote => description;

  void showCard(BuildContext context, noteTitle, noteDescription) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Text(
            noteTitle,
          ),
          content: Text(noteDescription.isNotEmpty
              ? noteDescription
              : "There is no desciption"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }
}
