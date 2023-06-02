import 'package:flutter/material.dart';
import 'package:todo_list/models/training_coac.dart';
import 'package:todo_list/models/user.dart';

import '../models/activity.dart';

class ActivityProvider extends ChangeNotifier{
  Activity _activity = Activity(id: 0, date: DateTime.now(),description: "",image: "",title: "",coachName: "");
  bool _isRegistered = false;

  void setIsRegistered(bool isR){
    _isRegistered = isR;
    notifyListeners();
  }
  bool getIsRegistered() => _isRegistered;

  void set(Activity incomingActivity){
    _activity = incomingActivity;
    notifyListeners();
  }
  Activity get() => _activity;
}