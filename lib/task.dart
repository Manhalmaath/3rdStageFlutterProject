import 'package:flutter/material.dart';

class Task {
  int? id;
  final String title;
  bool isDone;
  final String description;

  Task({this.id,required this.title, this.isDone = false, this.description = ''});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_done': isDone ? 1 : 0,
    };
  }

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        isDone = map['is_done'] == 1;

    void showCard(BuildContext context) {
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
          content: Text(
              description.isNotEmpty ? description : "There is no desciption"),
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
