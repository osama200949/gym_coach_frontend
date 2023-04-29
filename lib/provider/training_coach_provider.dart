import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/training_coac.dart';
import 'package:todo_list/models/user.dart';

class TrainingCoachProvider extends ChangeNotifier{
  TrainingCoach _user = TrainingCoach(email: "",image: "", name: "",gender: "",age: 0,height: 0,weight: 0,typeOfTraining: "");

  void set(TrainingCoach user2){
    _user = user2;
    notifyListeners();
  }

  TrainingCoach get() => _user;
}