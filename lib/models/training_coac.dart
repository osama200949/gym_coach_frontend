import 'dart:convert';
import 'dart:io';

class TrainingCoach {
  int id;
  String ?image;
  String name;
  String email;
  String gender;
  int age;
  String typeOfTraining;

  TrainingCoach(
      {this.id = 0,
      required this.email,
      required this.image,
      required this.name,
      required this.gender,
      required this.age,
      required this.typeOfTraining,
      });

  TrainingCoach.fromJson(Map<dynamic, dynamic> json)
      : this(
          id: json['id'],
          image: json['image'],
          name: json['name'],
          email: json['email'],
          gender: json['gender'],
          age: int.parse(json['age'].toString()),
          typeOfTraining: json['typeOfTraining'],
        );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'email': email,
  //       'password': password,
  //     };
}
