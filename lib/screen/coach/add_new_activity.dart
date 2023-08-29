import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/activity.dart';
import '../../models/customer.dart';
import '../../provider/activity_provider.dart';
import '../../provider/training_provider.dart';
import '../../provider/user_provider.dart';

class AddNewActivityScreen extends StatefulWidget {
  @override
  State<AddNewActivityScreen> createState() => _AddNewActivityScreenState();
}

class _AddNewActivityScreenState extends State<AddNewActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  // DateTime date = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String coachName = "";
  String coachId = "";
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


  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027, 12, 31), // You can adjust this range
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: true).get();
    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();

    String originalDate = activityProvider.date.toString();
    int spaceIndex = originalDate.indexOf(' ');
    // String date = originalDate.substring(0, spaceIndex);

    return Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            pickImage();
                          },
                          child: Text('Choce an image'),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () => pickImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coach: ${user.name}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            autofocus: false,
                            decoration: InputDecoration(
                              // prefixIcon: Icon(FontAwesomeIcons.t),
                              hintText: 'Title',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onChanged: (value) => title = value,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            minLines: 5,
                            maxLines: 10,
                            autofocus: false,
                            decoration: InputDecoration(
                              // prefixIcon: Icon(FontAwesomeIcons.user),
                              hintText: 'description',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onChanged: (value) => description = value,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onTap: () => _selectDate(context),
                            readOnly: true,
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.calendar),
                              hintText:
                                  "${selectedDate.toLocal()}".split(' ')[0],
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !keyboardIsOpened
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                    heroTag: "btn-1",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text('Cancel')),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton.extended(
                    heroTag: "btn-2",
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_image?.path == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please insert an image')),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        await service.createNewActivity(
                            Activity(
                                coachId: user.id,
                                coachName: user.name,
                                date: selectedDate,
                                description: description,
                                image: _image?.path,
                                title: title),
                            user.token);
                        Navigator.pop(context);
                      }
                    },
                    label: Text(
                      'Create new activity',
                      style: TextStyle(color: Colors.deepOrange),
                    )),
              ],
            )
          : null,
    );
  }
}
