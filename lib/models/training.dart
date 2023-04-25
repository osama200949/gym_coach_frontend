import 'package:flutter/material.dart';

class Training {
  int id;
  String title;
  String description;
  String ?video;
  bool isCompleted;
  int coachId;
  int customerId;

  Training(
      {this.id = 0,
      required this.title,
      required this.description,
      required this.video,
      required this.isCompleted,
      required this.coachId,
      required this.customerId,   
      });

//   Training.fromJson(Map<String, dynamic> json)
//       : this(
//           id: json['id'],
//           title: json['title'],
//           description: json['description'],
//           image: json['image'],
//         );

//   Map<String, dynamic> toJson() =>
//       {'id': id, 'title': title, 'description': description, 'image': image};
// }