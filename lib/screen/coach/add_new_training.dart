import 'package:flutter/material.dart';
import 'package:todo_list/widgets/appbar.dart';

class AddNewTrainingScreen extends StatefulWidget {
  const AddNewTrainingScreen({super.key});

  @override
  State<AddNewTrainingScreen> createState() => _AddNewTrainingScreenState();
}

class _AddNewTrainingScreenState extends State<AddNewTrainingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedWeekday = 'Sunday'; //TODO: this should come from the previous page. 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar( context),
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter a video link';
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
                  value: _selectedWeekday,
                  onChanged: (value) {
                    setState(() {
                      _selectedWeekday = value!;
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
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      //
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                    // do something with the text field values
                    String title = _titleController.text;
                    String description = _descriptionController.text;
                    String videoLink = _videoLinkController.text;
                    String weekday = _selectedWeekday;
                    print('Title: $title');
                    print('Description: $description');
                    print('Video Link: $videoLink');
                    print('Weekday: $weekday');
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
