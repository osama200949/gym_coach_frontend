import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar_with_no_back_btn.dart';

import '../models/user.dart';

const List<String> list = <String>[
  'Body builder',
  'Calisthenics',
  'Comprehensive'
];

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  File? _image;

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
    final user = Provider.of<UserProvider>(context, listen: true).get();
    String name = user.name;
    String age = user.age.toString();
    String height = user.height.toString();
    String weight = user.weight.toString();
    String typeOfTraining = user.typeOfTraining;
    DataService service = DataService();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              service.logout(user.token);
              await clearUserToken();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(
              Icons.logout,
              color: Colors.deepOrange,
            ),
          )
        ],
        title: appbarLogo,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _isEditing
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    InkWell(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : NetworkImage(
                                ("https://roae-almasat.com/public/images/${user.image}"),
                              ) as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Invalid name";
                                }
                              },
                              controller:
                                  TextEditingController(text: user.name),
                              decoration: InputDecoration(labelText: 'Name'),
                              onChanged: (value) => name = value,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return "Enter a valid age";
                                }
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false),
                              controller: TextEditingController(
                                  text: user.age.toString()),
                              decoration: InputDecoration(labelText: 'Age'),
                              onChanged: (value) => age = value,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return "Enter a valid height";
                                }
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              controller: TextEditingController(
                                  text: user.height.toString()),
                              decoration: InputDecoration(labelText: 'Height'),
                              onChanged: (value) => height = value,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return "Enter a valid weight";
                                }
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              controller: TextEditingController(
                                  text: user.weight.toString()),
                              decoration: InputDecoration(labelText: 'Weight'),
                              onChanged: (value) => weight = value,
                            ),
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
                              onChanged: (String? value) {
                                typeOfTraining = value!;
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_isEditing)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange),
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                });
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                // TODO: update the user data updateUser()
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );

                                  User newUser = await service.updateUser(
                                      User(
                                        image: _image?.path,
                                        name: name,
                                        age: int.parse(age),
                                        height: double.parse(height),
                                        weight: double.parse(weight),
                                        typeOfTraining: typeOfTraining,
                                        email: user.email, // unchanged
                                        gender: user.gender, // unchanged
                                        role: user.role, // unchanged
                                        id: user.id, // unchanged
                                        token: user.token, // unchanged
                                      ),
                                      user.token);

                                  setState(() {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .set(newUser);
                                    _isEditing = false;
                                  });
                                }
                              },
                              child: Text('Save Changes'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: CachedNetworkImageProvider(
                        "https://roae-almasat.com/public/images/${user.image}"),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(user.email),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.name,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Age',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.age.toString(),
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Height',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.height.toString(),
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.weight.toString(),
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Type of training',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.typeOfTraining,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            child: Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Future<void> clearUserToken() async {
  final storage = FlutterSecureStorage();
  await storage.deleteAll();
}
