import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../provider/training_provider.dart';
import '../provider/user_provider.dart';

class TrainingDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Training training =
        Provider.of<TrainingProvider>(context, listen: true).get();
    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();

    String videoId = YoutubePlayer.convertUrlToId(
            training.video as String)
        as String;
    return Scaffold(
      appBar: CustomAppBar(context),
      body: Column(
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
          ),
        ],
      ),
      floatingActionButton: user.role == 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Are you sure you want to delete?'),
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
                                      id: training.id, token: user.token);
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
                  },
                  child: Icon(
                    Icons.delete,
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
            )
          : FloatingActionButton(
              onPressed: () async {
                await launch(training.video as String);
              },
              child: Icon(
                Icons.play_arrow,
              ),
            ),
    );
  }
}
