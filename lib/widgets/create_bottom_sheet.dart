import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/carousel.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';
import 'dart:io';

void carouselBottomSheet(sheetContext) {
  DataService service = DataService();
  final user = Provider.of<UserProvider>(sheetContext, listen:false).get();
  String title = "";
  String description = "";
  FilePickerResult? picked = null;
  showModalBottomSheet(
      context: sheetContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Title",
                    ),
                    onChanged: ((value) => title = value),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                    ),
                    onChanged: ((value) => description = value),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text('UPLOAD FILE'),
                    onPressed: () async {
                      picked = await FilePicker.platform.pickFiles()
                          as FilePickerResult;

                      setState(() {});
                    },
                  ),
                  picked != null
                      ? Text(picked?.files.first.name as String)
                      : SizedBox.shrink(),
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: OutlinedButton(
                      style:
                          OutlinedButton.styleFrom(minimumSize: Size(100, 50)),
                      onPressed: () {
                        if (picked != null) {
                          File file = File(picked?.files.single.path as String);
                          service.createCarouselWithImage(Carousel(
                            title: title,
                            description: description,
                            image: file.path as String,
                          ), user.token);
                        } else {
                          service.createCarousel(
                              carousel: Carousel(
                            title: title,
                            description: description,
                            image: null,
                          ), token: user.token);
                        }

                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Submit"),
                    ),
                  ))
                ],
              ),
            ),
          ),
        );
      });
}
