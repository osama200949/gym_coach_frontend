import 'dart:convert';

class User {
  int id;
  String? image;
  String name;
  String email;
  String gender;
  int age;
  double height;
  double weight;
  String typeOfTraining;
  int role;
  String token;
  int points;

  User(
      {this.id = 0,
      this.points = 0,
      required this.image,
      required this.email,
      required this.name,
      required this.gender,
      required this.age,
      required this.height,
      required this.weight,
      required this.typeOfTraining,
      required this.role,
      required this.token});

  User.fromJson(Map<dynamic, dynamic> json)
      : this(
          id: json['id'],
          points: json['points'],
          image: json['image'],
          name: json['name'],
          email: json['email'],
          gender: json['gender'],
          age: int.parse(json['age'].toString()),
          height: double.parse(json['height'].toString()),
          weight: double.parse(json['weight'].toString()),
          typeOfTraining: json['typeOfTraining'],
          role: int.parse(json['role'].toString()),
          token: json['token'],
        );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'email': email,
  //       'password': password,
  //     };
}
