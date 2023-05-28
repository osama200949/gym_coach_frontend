import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/training_provider.dart';
import '../../provider/user_provider.dart';

class CoachTrainingDetailScreen extends StatefulWidget {
  @override
  State<CoachTrainingDetailScreen> createState() =>
      _CoachTrainingDetailScreenState();
}

class _CoachTrainingDetailScreenState extends State<CoachTrainingDetailScreen> {
  bool _isEditing = false;
  String title = "";
  String description = "";
  String videoUrl = "";

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    final Training training =
        Provider.of<TrainingProvider>(context, listen: true).get();

    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();

    String videoId =
        YoutubePlayer.convertUrlToId(training.video as String) as String;
    return Scaffold(
        appBar: CustomAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: videoId as String,
                    flags: YoutubePlayerFlags(
                      mute: true,
                      autoPlay: false,
                      hideControls: true,
                      disableDragSeek: true,
                      loop: false,
                    ),
                  ),
                ),
                builder: (context, player) {
                  return player;
                },
              ),
              if (!_isEditing)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coach: ${training.coachName}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 8),
                      Text(
                        training.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      Text(
                        training.description,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: training.title,
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (value) => title = value,
                      ),
                      TextFormField(
                        initialValue: training.description,
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (value) => description = value,
                      ),
                      TextFormField(
                        initialValue: training.video,
                        decoration: InputDecoration(labelText: 'Video URL'),
                        onChanged: (value) => videoUrl = value,
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
                                onPressed: () async {
                                  // TODO: update the training data
                                  Training newTraining =
                                      await service.updateTraining(Training(
                                          id: training.id,
                                          title: title != ""
                                              ? title
                                              : training.title,
                                          description: description != ""
                                              ? description
                                              : training.description,
                                          day: training.day,
                                          video: videoUrl != ""
                                              ? videoUrl
                                              : training.video,
                                          isCompleted: training.isCompleted,
                                          coachId: training.coachId,
                                          customerId: training.customerId,
                                          coachName: training.coachName), user.token);
                                  Provider.of<TrainingProvider>(context,
                                          listen: false)
                                      .set(newTraining);
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                child: Text('Save Changes'),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          // TODO: Delete the training data
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Are you sure you want to delete?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          service.deleteTraining(
                                              id: training.id,
                                              token: user.token);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          });
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: !keyboardIsOpen,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isEditing == true ? _isEditing = false : _isEditing = true;
                  });
                },
                child: Icon(
                  Icons.edit,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              FloatingActionButton(
                onPressed: () async {
                  await launch(training.video as String);
                },
                child: Icon(
                  Icons.play_arrow,
                ),
              ),
            ],
          ),
        ));
  }
}
