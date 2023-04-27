import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/user.dart';

class WeekdayProvider extends ChangeNotifier{
  String _weekday = "Sunday";

  void set(String weekday2){
    _weekday = weekday2;
    notifyListeners();
  }

  String get() => _weekday;
}