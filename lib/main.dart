import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/activity_provider.dart';
import 'package:todo_list/provider/customer_provider.dart';
import 'package:todo_list/provider/training_coach_provider.dart';
import 'package:todo_list/provider/training_provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/provider/weekday_provider.dart';
import 'package:todo_list/screen/coach/add_new_activity.dart';
import 'package:todo_list/screen/coach/add_new_training.dart';
import 'package:todo_list/screen/coach/coach_activity.dart';
import 'package:todo_list/screen/coach/coach_activity_detail.dart';
import 'package:todo_list/screen/coach/coach_actual_chat.dart';
import 'package:todo_list/screen/coach/coach_evaluation.dart';
import 'package:todo_list/screen/coach/coach_training_detail.dart';
import 'package:todo_list/screen/customer/customer_activity.dart';
import 'package:todo_list/screen/customer/customer_activity_detail.dart';
import 'package:todo_list/screen/customer/customer_actual_chat.dart';
import 'package:todo_list/screen/coach/coach_home.dart';
import 'package:todo_list/screen/coach/coach_training.dart';
import 'package:todo_list/screen/customer/customer_home.dart';
import 'package:todo_list/screen/customer/customer_prize.dart';
import 'package:todo_list/screen/register.dart';
import 'package:todo_list/screen/login.dart';
import 'package:todo_list/screen/customer/customer_training_detail.dart';
import 'dart:io';

import 'package:todo_list/services/rest.dart';

import 'models/user.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ActivityProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => TrainingProvider()),
      ChangeNotifierProvider(create: (context) => CustomerProvider()),
      ChangeNotifierProvider(create: (context) => WeekdayProvider()),
      ChangeNotifierProvider(create: (context) => TrainingCoachProvider()),
    ],
    child: MaterialApp(home: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserEmailAndPassword>(
      future: getUserEmailAmdPassword(),
      builder: (context, snapshot) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final service = DataService();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading anmiation
        } else {
          final emailAndPassword = snapshot.data;
          final isLoggedIn = emailAndPassword?.email != null;

          // Determine the initial route based on the token and role
          String initialRoute = isLoggedIn ? '/customerHomePage' : '/login';

          if (isLoggedIn) {
            return FutureBuilder<User>(
              future: service.authenticate(
                emailAndPassword?.email as String,
                emailAndPassword?.password as String,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.white,
                    child: Hero(
                      tag: 'hero',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Gym",
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 60),
                            ),
                            Text(
                              "Coach",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 60),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  final User user = snapshot.data as User;
                  userProvider.setInitialUser(user);
                  if (user.role == 1) {
                    initialRoute = '/coachHomePage';
                  }

                  // Return MaterialApp with the initialRoute
                  return MaterialApp(
                    title: 'Gym coach',
                    theme: ThemeData(
                      primarySwatch: Colors.deepOrange,
                    ),
                    initialRoute: initialRoute,
                    routes: buildRoutes(),
                  );
                }
              },
            );
          } else {
            // Return MaterialApp with the initialRoute
            return MaterialApp(
              title: 'Gym coach',
              theme: ThemeData(
                primarySwatch: Colors.deepOrange,
              ),
              initialRoute: initialRoute,
              routes: buildRoutes(),
            );
          }
        }
      },
    );
  }
}

Map<String, Widget Function(BuildContext)> buildRoutes() {
  return {
    '/evaluationPage': (context) => EvaluationScreen(),
    '/activityDetailPage': (context) => CustomerActivityDetailScreen(),
    '/customerActivityPage': (context) => CustomerActivityScreen(),
    '/customerTrophyPage': (context) => CustomerTrophyScreen(),
    '/customerChatPage': (context) => CustomerActualChatScreen(),
    '/coachChatPage': (context) => CoachActualChatScreen(),
    '/login': (context) => LoginScreen(),
    '/addNewActivity': (context) => AddNewActivityScreen(),
    '/coachActivityPage': (context) => CoachActivityScreen(),
    '/coachActivityDetailPage': (context) => CoachActivityDetailScreen(),
    '/coachTrainingDetailPage': (context) => CoachTrainingDetailScreen(),
    '/trainingDetailPage': (context) => CustomerTrainingDetailsScreen(),
    '/addNewTraining': (context) => AddNewTrainingScreen(),
    '/coachCustomerPage': (context) => CoachCustomerScreen(),
    '/customerHomePage': (context) => const CustomerHomeScreen(),
    '/coachHomePage': (context) => const CoachHomeScreen(),
    '/customerRegister': (context) => RegisterScreen(role: 0),
    '/coachRegister': (context) => RegisterScreen(role: 1),
  };
}

// Rest of your code remains unchanged
Future<UserEmailAndPassword> getUserEmailAmdPassword() async {
  final storage = FlutterSecureStorage();
  final email = await storage.read(key: 'user_email');
  final String password = await storage.read(key: 'user_password') ?? "";

  if (email == null) {
    return UserEmailAndPassword(null, null);
  }
  return UserEmailAndPassword(email, password);
}

class UserEmailAndPassword {
  final String? email;
  final String? password;

  UserEmailAndPassword(this.email, this.password);
}

final logo = Hero(
  tag: 'hero',
  child: CircleAvatar(
    backgroundColor: Colors.transparent,
    radius: 48.0,
    // child: Image.asset('assets/logo.png'),
    // child: FlutterLogo(size: 200),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Gym",
          style: TextStyle(color: Colors.deepOrange, fontSize: 60),
        ),
        Text(
          "Coach",
          style: TextStyle(color: Colors.black, fontSize: 60),
        ),
      ],
    ),
  ),
);
