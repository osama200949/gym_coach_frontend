import 'dart:convert';

class User {
  int id;
  String email;
  String name;
  String token;

  User({ this.id = 0, required this.email, required this.name, required this.token});

  User.fromJson(Map<dynamic, dynamic> json)
      : this(
          id: json['user']['id'],
          email: json['user']['email'],
          name: json['user']['name'],
          token: json['token'],
        );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'email': email,
  //       'password': password,
  //     };
}
