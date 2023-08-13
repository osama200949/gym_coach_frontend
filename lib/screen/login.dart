import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';
// import 'package:login/home_page.dart';

class LoginScreen extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserProvider userProvider = UserProvider();
  DataService service = DataService();
  String insertedEmail = "osama200949@gmail.com";
  String insertedPassword = "123456";
  @override
  Widget build(BuildContext context) {
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

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (value) => insertedEmail = value,
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: ((value) => insertedPassword = value),
    );
    final snackBar = SnackBar(
      content: const Text('Wrong credentials'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12)),
            backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: Colors.red)))),
        onPressed: () async {
          final userProvider2 =
              Provider.of<UserProvider>(context, listen: false);
          User user =
              await service.authenticate(insertedEmail, insertedPassword);
          print(insertedEmail);
          print(insertedPassword);
          print("The email is: " + user.email);
          if (user.email != "") {
            print("The id is: " + user.id.toString());
            userProvider2.set(user);
            await storeUserToken(user.email,
                insertedPassword); //! Stor user token in the local storage

            print(userProvider2.get().name);
            if (userProvider2.get().role == 1) {
              Navigator.pushReplacementNamed(context, '/coachHomePage');
            } else {
              Navigator.pushReplacementNamed(context, '/customerHomePage');
            }

            // Navigator.of(context).pushNamed('/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            print("wrong credentials");
          }
        },
        child:
            Text('Log In', style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );

    final customerBtn = TextButton(
      child: Text(
        'Register as a new customer',
        style: TextStyle(color: Colors.deepOrange),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/customerRegister');
      },
    );
    final coachBtn = TextButton(
      child: Text(
        'Register as a new coach',
        style: TextStyle(color: Colors.deepOrange),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/coachRegister');
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            SizedBox(height: 24.0),
            customerBtn,
            coachBtn
          ],
        ),
      ),
    );
  }
}

Future<void> storeUserToken(String email, String password) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'user_email', value: email);
  await storage.write(key: 'user_password', value: password);
}
