import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo_list/models/carousel.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/models/customer.dart';
import 'package:todo_list/models/product.dart';
import 'package:todo_list/models/user.dart';

import '../models/training.dart';
import '../models/training_coac.dart';

class DataService {
  String baseUrl =
      // "http://127.0.0.1:8000/api"; // Change the IP address to your PC's IP. Remain the port number 3000 unchanged.
      "http://10.0.2.2:8000/api"; // Change the IP address to your PC's IP. Remain the port number 3000 unchanged.
  // 'http://192.168.56.1:3000'; // Change the IP address to your PC's IP. Remain the port number 3000 unchanged.

  // TODO 1: Complete this method. It is an helper for the HTTP GET request
  Future get(String endpoint, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  Future post(String endpoint, {dynamic data, required String token}) async {
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  // TODO new: Complete this method. It is an helper for the HTTP PATCH request
  Future put(String endpoint, {dynamic data}) async {
    final response = await http.patch(Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);
      return jsonDecode(response.body);
    }
    throw response;
  }

  //! Carousel
  Future<bool> deleteCarousel(id, String token) async {
    final response = await http.delete(
      Uri.parse(
        '$baseUrl/carousels/$id',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editCarousel(Carousel carousel, String token) async {
    var body;
    if (carousel.image != null) {
      String filepath = carousel.image as String;
      String fileName = filepath.split('/login').last;

      body = FormData.fromMap({
        "title": carousel.title,
        "description": carousel.description,
        "image": await MultipartFile.fromFile(filepath, filename: fileName)
      });
    } else {
      body = FormData.fromMap({
        "title": carousel.title,
        "description": carousel.description,
        "image": null
      });
    }
    var response = await Dio().post(
      '$baseUrl/carousels/${carousel.id}',
      data: body,
      options: Options(
          headers: {"Authorization": "Bearer $token"},
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Carousel>> getCarousels(String token) async {
    final listJson = await get("carousels", token);
    final list = (listJson as List)
        .map((itemJson) => Carousel.fromJson(itemJson))
        .toList();
    return list;
  }

  Future<Training> createNewTraining(
      {required Training training, required String token}) async {
    final json =
        await post('coaches/createTraining', data: training, token: token);
    return Training.fromJson(json);
  }

  Future<List<TrainingCoach>> getCoaches(
      {required String token, required String typeOfTraining}) async {
    final listJson = await get("coaches/$typeOfTraining", token);
    final list = (listJson as List)
        .map((itemJson) => TrainingCoach.fromJson(itemJson))
        .toList();
    return list;
  }

  Future<List<Customer>> getCustomers(
      {required String token, required String typeOfTraining}) async {
    final listJson = await get("customers/$typeOfTraining", token);
    final list = (listJson as List)
        .map((itemJson) => Customer.fromJson(itemJson))
        .toList();
    return list;
  }

  Future<List<Training>> getCustomerTraining(
      {required int customerId, required String token}) async {
    try {
      final listJson = await get("customers/training/$customerId", token);
      final list = (listJson as List)
          .map((itemJson) => Training.fromJson(itemJson))
          .toList();
      return list;
    } catch (e) {
      print(e);
      List<Training> t = [];
      return t;
    }
  }

  Future<Carousel> createCarousel(
      {required Carousel carousel, required String token}) async {
    final json = await post('carousels', data: carousel, token: token);
    return Carousel.fromJson(json);
  }

  Future<bool> createCarouselWithImage(Carousel carousel, String token) async {
    String filepath = carousel.image as String;
    String fileName = filepath.split('/login').last;

    var body = FormData.fromMap({
      "title": carousel.title,
      "description": carousel.description,
      "image": await MultipartFile.fromFile(filepath, filename: fileName)
    });

    var response = await Dio().post(
      '$baseUrl/carousels',
      data: body,
      options: Options(
          headers: {"Authorization": "Bearer $token"},
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //! Product
  Future<List<Product>> getProducts(String token) async {
    final listJson = await get("products", token);
    return (listJson as List)
        .map((itemJson) => Product.fromJson(itemJson))
        .toList();
  }

  //! Users
  Future<User> authenticate(String email, String password) async {
    var body = FormData.fromMap({
      "email": email,
      "password": password,
    });
    try {
      final response = await Dio().post('$baseUrl/login', data: body);
      if (response.statusCode == 201) {
        print(response.data);
        final parsed = User.fromJson(response.data);
        print(parsed.email);
        return parsed;
      } else {
        return User(
            image: "",
            email: "",
            name: "",
            gender: "",
            age: 0,
            height: 0,
            weight: 0,
            typeOfTraining: "",
            role: 0,
            token: "");
      }
    } on DioError catch (e) {
      return User(
          image: "",
          email: "",
          name: "",
          gender: "",
          age: 0,
          height: 0,
          weight: 0,
          typeOfTraining: "",
          role: 0,
          token: "");
    }
  }

  Future<User> register(
      {role,
      image,
      name,
      email,
      gender,
      age,
      height,
      weight,
      typeOfTraining,
      password,
      password_confirmation}) async {
    String filepath = image as String;
    String fileName = filepath.split('/login').last;
    print(filepath);
    var body = FormData.fromMap({
      "image": await MultipartFile.fromFile(filepath, filename: fileName),
      "name": name,
      "email": email,
      "gender": gender,
      "age": age,
      "height": height,
      "weight": weight,
      "typeOfTraining": typeOfTraining,
      "role": role,
      "password": password,
      "password_confirmation": password_confirmation
    });
    try {
      final response = await Dio().post('$baseUrl/register', data: body);
      print(response);
      final parsed = User.fromJson(response.data);
      return parsed;
    } on DioError catch (e) {
      print(e);
      return User(
          image: "",
          name: "",
          email: "",
          gender: "",
          age: 0,
          height: 0,
          weight: 0,
          typeOfTraining: "",
          role: 0,
          token: "");
    }
  }

  // Future<User> register(
  //     {image,
  //     name,
  //     email,
  //     gender,
  //     age,
  //     height,
  //     weight,
  //     typeOfTraining,
  //     password,
  //     password_confirmation}) async {
  //   var body = FormData.fromMap({
  //     "name": name,
  //     "email": email,
  //     "gender": gender,
  //     "age": age,
  //     "height": height,
  //     "weight": weight,
  //     "typeOfTraining": typeOfTraining,
  //     "password": password,
  //     "role": 0,
  //     "password_confirmation": password_confirmation
  //   });
  //   try {
  //     final response = await Dio().post('$baseUrl/register', data: body);
  //     print(response);
  //     final parsed = User.fromJson(response.data);
  //     return parsed;
  //   } on DioError catch (e) {
  //     print(e);
  //     return User(
  //         image: "",
  //         email: "",
  //         name: "",
  //         gender: "",
  //         age: 0,
  //         height: 0,
  //         weight: 0,
  //         typeOfTraining: "",
  //         role: 0,
  //         token: "");
  //   }
  // }

  Future<bool> logout(String token) async {
    try {
      final response = await Dio().post(
        '$baseUrl/logout',
        options: Options(
            headers: {"Authorization": "Bearer $token"},
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    }
  }
}
