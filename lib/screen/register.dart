import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/screen/test.dart';
import 'package:todo_list/services/rest.dart';

import '../widgets/appbar.dart';

const List<String> list = <String>[
  'Body builder',
  'Calisthenics',
  'Comprehensive'
];

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key, required this.role}) : super(key: key);
  int role;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

Gender _selectedGender = Gender.Male;

class _RegisterScreenState extends State<RegisterScreen> {
  String? typeOfTraining;
  final _formKey = GlobalKey<FormState>();
  DataService service = DataService();
  String insertedName = "";
  String insertedEmail = "";
  String gender = "male";
  int age = 0;
  double height = 0;
  double weight = 0;
  String insertedPassword = "";
  String insertedPasswordConfirmation = "";
  File? _image;
  String _defaultImage = "assets/images/profile.png";

  Future pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ageController = TextEditingController();
    final heightController = TextEditingController();
    final weightController = TextEditingController();

    @override
    void dispose() {
      ageController.dispose();
      heightController.dispose();
      weightController.dispose();
      super.dispose();
    }

    final name = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your name';
        }
        return null;
      },
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your email';
        }
        return null;
      },
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your password';
        }
        return null;
      },
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline),
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: ((value) {
        insertedPassword = value;
        print(value);
      }),
    );

    final passwordConfirmation = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm your password';
        }
        return null;
      },
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
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12)),
            backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: Colors.red)))),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            print(insertedName);
            print(insertedEmail);
            print(gender);
            print(age);
            print(height);
            print(weight);
            print(typeOfTraining);
            print(insertedPassword);
            print(_image?.path);
            User user = await service.register(
                role: widget.role,
                image: _image?.path,
                name: insertedName,
                email: insertedEmail,
                gender: gender,
                age: age,
                height: height,
                weight: weight,
                typeOfTraining: typeOfTraining,
                password: insertedPassword,
                password_confirmation: insertedPasswordConfirmation);
            if (user.email != "") {
              Navigator.of(context).pushNamed('/login');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print("wrong credentials");
            }
          }
        },
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(context),
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              CircleAvatar(
                radius: 100,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : AssetImage(_defaultImage) as ImageProvider,
              ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Select Image'),
              ),
              name,
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),

              // Gender
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Gender:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: Gender.Male,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = Gender.Male;
                            gender = Gender.Male.toString()
                                .substring(7)
                                .toLowerCase();
                            print(gender);
                          });
                        },
                      ),
                      Text('Male'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: Gender.Female,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          _selectedGender = Gender.Female;
                          print(Gender.Female.toString()
                              .substring(7)
                              .toLowerCase());
                          gender = Gender.Female.toString()
                              .substring(7)
                              .toLowerCase();
                          print(gender);
                          setState(() {});
                        },
                      ),
                      Text('Female'),
                    ],
                  ),
                ],
              ),

              // age
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Age:"),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 100,
                    child: TextFormField(
                      controller: ageController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          // labelText: 'Enter your age',
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your age';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty)
                          age = int.parse(value);
                        else
                          age = 0;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // height and weight
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Height:"),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 100,
                    child: TextFormField(
                      controller: heightController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your height';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty)
                          height = double.parse(value);
                        else
                          height = 0;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // weight
                  Text("Weight:"),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 100,
                    child: TextFormField(
                      controller: weightController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your weight';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty)
                          weight = double.parse(value);
                        else
                          weight = 0;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              // Type of training
              // Type of training
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter type of training';
                  }
                  return null;
                },
                hint: Text("Type of training"),
                value: typeOfTraining,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepOrange),
                // underline: Container(
                //   height: 2,
                //   color: Colors.deepOrangeAccent,
                // ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  // setState(() {
                  typeOfTraining = value!;
                  // });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              SizedBox(height: 20.0),
              password,
              SizedBox(height: 8.0),
              passwordConfirmation,
              SizedBox(height: 24.0),
              registerButton,
            ],
          ),
        ),
      ),
    );
  }
}
