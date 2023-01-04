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

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
      'description': description,
      'isDone': isDone
    };
  }

  @override
  String toString() {
    return 'toDO{id: $id, title: $title,description:$description,isDone:$isDone}';
  }

  get ID => id;

  get descriptionOfTheNote => description;

  void showCard(BuildContext context, title, description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Text(
            title,
          ),
          content: Text(description.isNotEmpty
              ? description
              : "There is no description for this task"),
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
