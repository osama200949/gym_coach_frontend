import 'package:flutter/material.dart';
import 'package:todo_list/models/coach.dart';

class CoachProvider extends ChangeNotifier{
  Coach _user = Coach(image: "",email: "", name: "",gender: "",age: 0,typeOfTraining: "", token: "");

  void set(Coach user2){
    _user = user2;
    notifyListeners();
  }

  Coach get() => _user;
}