import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/provider/training_provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/provider/weekday_provider.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar.dart';

import '../../provider/customer_provider.dart';
import '../../provider/training_provider.dart';

class AddNewTrainingScreen extends StatefulWidget {
  AddNewTrainingScreen({super.key});

  @override
  State<AddNewTrainingScreen> createState() => _AddNewTrainingScreenState();
}

class _AddNewTrainingScreenState extends State<AddNewTrainingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // String _selectedWeekday =

  @override
  Widget build(BuildContext context) {
    DataService service = DataService();
    final customer = Provider.of<CustomerProvider>(context, listen: true).get();
    final user = Provider.of<UserProvider>(context, listen: true).get();
    final String weekday =
        Provider.of<WeekdayProvider>(context, listen: true).get();

    String selectedWeekDay = weekday;
    return Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter title here',
                    icon: Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  maxLines: null, // allow multiple lines of text

                  decoration: InputDecoration(
                    hintText: 'Enter description here',
                    icon: Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Video Link',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r"^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})")
                            .hasMatch(value)) {
                      return 'Please enter a valid YouTube video link';
                    }
                    return null;
                  },
                  controller: _videoLinkController,
                  decoration: InputDecoration(
                    hintText: 'Enter video link here',
                    icon: Icon(Icons.videocam),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Weekday',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedWeekDay,
                  onChanged: (value) {
                    setState(() {
                      selectedWeekDay = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Monday',
                      child: Text('Monday'),
                    ),
                    DropdownMenuItem(
                      value: 'Tuesday',
                      child: Text('Tuesday'),
                    ),
                    DropdownMenuItem(
                      value: 'Wednesday',
                      child: Text('Wednesday'),
                    ),
                    DropdownMenuItem(
                      value: 'Thursday',
                      child: Text('Thursday'),
                    ),
                    DropdownMenuItem(
                      value: 'Friday',
                      child: Text('Friday'),
                    ),
                    DropdownMenuItem(
                      value: 'Saturday',
                      child: Text('Saturday'),
                    ),
                    DropdownMenuItem(
                      value: 'Sunday',
                      child: Text('Sunday'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Select a weekday',
                    icon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(height: 10.0),
                OutlinedButton(
                  child: Text('Add'),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      //
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );

                      String title = _titleController.text;
                      String description = _descriptionController.text;
                      String videoLink = _videoLinkController.text;
                      String weekday = selectedWeekDay;
                      print('Title: $title');
                      print('Description: $description');
                      print('Video Link: $videoLink');
                      print('Weekday: $weekday');
                      Training training = Training(
                          coachId: user.id,
                          customerId: customer.id,
                          coachName: user.name,
                          id: 0,
                          day: weekday,
                          description: description,
                          title: title,
                          isCompleted: 0,
                          video: videoLink);
                      service.createNewTraining(
                          training: training, token: user.token);
                      Navigator.pop(context);
                    }
                    // do something with the text field values
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
