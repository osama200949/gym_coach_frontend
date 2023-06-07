import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

class _AddNewActivityScreenState extends State<AddNewActivityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
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
                      child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your name';
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
                            return 'Enter your name';
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
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2027, 12, 25),
                              onChanged: (newDate) {
                            print('change $newDate');
                            FocusManager.instance.primaryFocus?.unfocus();
                          }, onConfirm: (newDate) {
                            print('confirm $newDate');
                            FocusManager.instance.primaryFocus?.unfocus();
                            date = newDate;
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        // keyboardType: TextInputType.datetime,
                        autofocus: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.calendar),
                          hintText: date.toString().substring(0, 11),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text('Cancel')),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton.extended(
              backgroundColor: Colors.white,
              onPressed: () async {
                await service.createNewActivity(
                    Activity(
                        coachId: user.id,
                        coachName: user.name,
                        date: date,
                        description: description,
                        image: _image?.path,
                        title: title),
                    user.token);
                Navigator.pop(context);
              },
              label: Text(
                'Create new activity',
                style: TextStyle(color: Colors.deepOrange),
              )),
        ],
      ),
    );
  }
}
