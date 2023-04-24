import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/user.dart';

class UserProvider extends ChangeNotifier{
  User _user = User(email: "",image: "", name: "",gender: "",age: 0,height: 0,weight: 0,typeOfTraining: "",role: 0, token: "");

  void set(User user2){
    _user = user2;
    notifyListeners();
  }

  User get() => _user;
}