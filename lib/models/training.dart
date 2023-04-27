import 'package:flutter/material.dart';

class Training {
  int id;
  String title;
  String description;
  String day;
  String ?video;
  bool isCompleted;
  int coachId;
  int customerId;
  String coachName;

  Training(
      {this.id = 0,
      required this.title,
      required this.description,
      required this.day,
      required this.video,
      required this.isCompleted,
      required this.coachId,
      required this.customerId,
      required this.coachName   
      });

  Training.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          day: json['day'],
          video: json['video'],
          isCompleted: json['isCompleted'],
          coachId: json['coachId'],
          customerId: json['customerId'],
          coachName: json['coachName'],
        );

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'description': description, 'video': video, 'day':day,'isCompleted':isCompleted
      ,'coachId':coachId, 'customerId':customerId, 'coachName':coachName};
}
