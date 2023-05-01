import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar_with_no_back_btn.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              service.logout(user.token);
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
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                          "http://192.168.75.1/gym_coach/public/images/${user.image}"),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: TextEditingController(text: user.name),
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          TextField(
                            controller: TextEditingController(text: user.email),
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          TextField(
                            controller: TextEditingController(
                                text: user.age.toString()),
                            decoration: InputDecoration(labelText: 'Age'),
                          ),
                          TextField(
                            controller: TextEditingController(
                                text: user.height.toString()),
                            decoration: InputDecoration(labelText: 'Height'),
                          ),
                          TextField(
                            controller: TextEditingController(
                                text: user.weight.toString()),
                            decoration: InputDecoration(labelText: 'Weight'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_isEditing)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                });
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        "http://192.168.75.1/gym_coach/public/images/${user.image}"),
                  ),
                  SizedBox(height: 20),
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
                        SizedBox(height: 20.0),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.email,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0),
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
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
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
