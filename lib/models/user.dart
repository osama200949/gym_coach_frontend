import 'dart:convert';

class User {
  int id;
  String ?image;
  String name;
  String email;
  String gender;
  int age;
  double height;
  double weight;
  String typeOfTraining;
  int role;
  String token;

  User(
      {this.id = 0,
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
          id: json['user']['id'],
          image: json['user']['image'],
          name: json['user']['name'],
          email: json['user']['email'],
          gender: json['user']['gender'],
          age: int.parse(json['user']['age'].toString()),
          height: double.parse(json['user']['height'].toString()),
          weight: double.parse(json['user']['weight'].toString()),
          typeOfTraining: json['user']['typeOfTraining'],
          role: int.parse(json['user']['role'].toString()),
          token: json['token'],
        );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'email': email,
  //       'password': password,
  //     };
}
