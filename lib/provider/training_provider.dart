import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/user.dart';

import '../models/training.dart';

class TrainingProvider extends ChangeNotifier {
  Training _training = Training(
    title: "The Bodybuilder's Back Workout for Beginners",
    description:
        "Wide grip pull-down 3 sets of 12 reps Grip the bar with shoulder-width palms facing away and your arms fully extended above your head. Do not lean back as you pull the bar to the top of your chest and hold it there for two seconds. Control the bar as it pulls itself back to the start position, aiming for a three second ascent with no pause at the top of the movement.",
    day: "Sunday",
    video:
        "https://www.youtube.com/watch?v=t-h0T3dE8t4&pp=ygUVYm9keSBidWlsZGVyIHRyYWluaW5n",
    isCompleted: false,
    coachId: 2,
    customerId: 3,
    coachName: "Osama Abdalla",
  );

  void set(Training incomingTraining) {
    _training = incomingTraining;
    notifyListeners();
  }

  Training get() => _training;
}
