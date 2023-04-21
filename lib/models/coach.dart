import 'dart:convert';
import 'dart:io';

class Coach {
  int id;
  String ?image;
  String name;
  String email;
  String gender;
  int age;
  String typeOfTraining;
  String token;

  Coach(
      {this.id = 0,
      required this.email,
      required this.image,
      required this.name,
      required this.gender,
      required this.age,
      required this.typeOfTraining,
      required this.token});

  Coach.fromJson(Map<dynamic, dynamic> json)
      : this(
          id: json['user']['id'],
          image: json['user']['image'],
          name: json['user']['name'],
          email: json['user']['email'],
          gender: json['user']['gender'],
          age: int.parse(json['user']['age'].toString()),
          typeOfTraining: json['user']['typeOfTraining'],
          token: json['token'],
        );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'email': email,
  //       'password': password,
  //     };
}
