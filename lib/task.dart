import 'package:flutter/material.dart';

class Task {
  final String title;
  bool isDone;
  final String description;

  Task({required this.title, this.isDone = false, this.description = ''});

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

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isDone: json['isDone'],
      description: json['description'],
    );
  }
}
