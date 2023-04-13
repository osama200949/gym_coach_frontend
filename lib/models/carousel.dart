import 'package:flutter/material.dart';

class Carousel {
  int id;
  String title;
  String description;
  String ?image;

  Carousel(
      {this.id = 0,
      required this.title,
      required this.description,
      required this.image});

  Carousel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          image: json['image'],
        );

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'description': description, 'image': image};
}
