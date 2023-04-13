import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/user.dart';

class UserProvider extends ChangeNotifier{
  User _user = User(email: "", name: "", token: "");

  void set(User user2){
    _user = user2;
    notifyListeners();
  }

  User get() => _user;
}