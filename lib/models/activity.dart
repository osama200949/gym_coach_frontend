// import 'package:flutter/material.dart';

class Activity {
  int id;
  String title;
  String description;
  String image;
  String coachName;
  DateTime date;

  Activity(
      {required this.id,
      required this.title,
      required this.description,
      required this.coachName,
      required this.image,
      required this.date});

  Activity.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          coachName: json['coachName'],
          image: json['image'],
          date: DateTime.parse(json['date']),
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'coachName': coachName,
        'image': image,
        'date': date.toString()
      };
}
