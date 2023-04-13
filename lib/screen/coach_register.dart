import 'package:flutter/material.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/services/rest.dart';

class CoachRegisterScreen extends StatefulWidget {
  const CoachRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CoachRegisterScreen> createState() => _CoachRegisterScreenState();
}

class _CoachRegisterScreenState extends State<CoachRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    DataService service = DataService();
    String insertedName = "";
    String insertedEmail = "";
    String insertedPassword = "";
    String insertedPasswordConfirmation = "";
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        // child: Image.asset('assets/logo.png'),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "H",
              style: TextStyle(color: Colors.blue, fontSize: 70),
            ),
            Text(
              "YAPE",
              style: TextStyle(color: Colors.black, fontSize: 70),
            ),
          ],
        ),
      ),
    );

    final name = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (value) => insertedName = value,
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
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
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: ((value) => insertedPassword = value),
    );

    final passwordConfirmation = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password confirmation',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: ((value) => insertedPasswordConfirmation = value),
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
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          User user = await service.register(
              name: insertedName,
              email: insertedEmail,
              password: insertedPassword,
              password_confirmation: insertedPasswordConfirmation);
          if (user.email != "") {
            Navigator.of(context).pushNamed('/login');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            print("wrong credentials");
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
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
            name,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8.0),
            passwordConfirmation,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }
}
