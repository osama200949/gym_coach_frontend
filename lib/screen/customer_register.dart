import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/services/rest.dart';

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    DataService service = DataService();
    String insertedName = "";
    String insertedEmail = "";
    int age;
    String gender;
    String typeOfTraining;
    double weight;
    double height;
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

    final name = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(FontAwesomeIcons.user),
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
        prefixIcon: Icon(Icons.mail_outline),
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
        prefixIcon: Icon(Icons.lock_outline),
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
        prefixIcon: Icon(Icons.lock_outline),
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
    final registerButton = Padding(
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
        color: Colors.deepOrange,
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
            GenderPickerWithImage(
              showOtherGender: false,
              verticalAlignedText: false,
              selectedGender: Gender.Male,
              selectedGenderTextStyle: TextStyle(
                  color: Colors.deepOrange, fontWeight: FontWeight.bold),
              unSelectedGenderTextStyle: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal),
              onChanged: (gender2) {
                gender = gender2.toString();
                gender = gender.substring(7);
                gender = gender.toLowerCase();
                print(gender);
              },
              equallyAligned: false,
              animationDuration: Duration(milliseconds: 300),
              isCircular: true,
              // default : true,
              opacityOfGradient: 0.4,
              padding: const EdgeInsets.all(0),
              size: 60, //default : 40
            ),
            SizedBox(height: 10.0),
            password,
            SizedBox(height: 8.0),
            passwordConfirmation,
            SizedBox(height: 24.0),
            registerButton,
          ],
        ),
      ),
    );
  }
}
