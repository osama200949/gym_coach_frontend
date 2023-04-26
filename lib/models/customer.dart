import 'dart:convert';
import 'dart:io';

class Customer {
  int id;
  String ?image;
  String name;
  String email;
  String gender;
  int age;
  double height;
  double weight;
  String typeOfTraining;

  Customer(
      {this.id = 0,
      required this.email,
      required this.image,
      required this.name,
      required this.gender,
      required this.age,
      required this.height,
      required this.weight,
      required this.typeOfTraining,
      });

  Customer.fromJson(Map<dynamic, dynamic> json)
      : this(
          id: json['id'],
          image: json['image'],
          name: json['name'],
          email: json['email'],
          gender: json['gender'],
          age: int.parse(json['age'].toString()),
          height: double.parse(json['height'].toString()),
          weight: double.parse(json['weight'].toString()),
          typeOfTraining: json['typeOfTraining'],
        );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'email': email,
  //       'password': password,
  //     };
}
