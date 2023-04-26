import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/provider/training_provider.dart';
import 'package:todo_list/widgets/appbar_with_no_back_btn.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/customer_provider.dart';
import '../../widgets/appbar.dart';

class CoachCustomerScreen extends StatefulWidget {
  const CoachCustomerScreen({super.key});

  @override
  State<CoachCustomerScreen> createState() => _CoachCustomerScreenState();
}

class _CoachCustomerScreenState extends State<CoachCustomerScreen> {
  List<Training> trainings = [
    Training(
      title: "The Bodybuilder's Back Workout for Beginners testing 2",
      description:
          "Wide grip pull-down 3 sets of 12 reps Grip the bar with shoulder-width palms facing away and your arms fully extended above your head. Do not lean back as you pull the bar to the top of your chest and hold it there for two seconds. Control the bar as it pulls itself back to the start position, aiming for a three second ascent with no pause at the top of the movement.",
      day: "Sunday",
      video:
          "https://www.youtube.com/watch?v=t-h0T3dE8t4&pp=ygUVYm9keSBidWlsZGVyIHRyYWluaW5n",
      isCompleted: false,
      coachId: 2,
      customerId: 3,
      coachName: "Osama Abdalla",
    ),
  ];
  final String videoUrl =
      "https://www.youtube.com/watch?v=t-h0T3dE8t4&pp=ygUVYm9keSBidWlsZGVyIHRyYWluaW5n";

  @override
  Widget build(BuildContext context) {
     final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);
     final customer = Provider.of<CustomerProvider>(context, listen: true).get();

    String videoId =
        YoutubePlayer.convertUrlToId(trainings[0].video as String) as String;
    return Scaffold(
      appBar: appBar( context,customer.name),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < 1; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _getWeekdayName(i),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Container(
                    height: 230,
                    // color: Colors.red,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            width: 250,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                              // color: Colors.yellow
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/addNewTraining");
                                  },
                                  child: Container(
                                      width: 150,
                                      height: 150,
                                      // color: Colors.yellow,
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Colors.grey),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                2.0, // soften the shadow
                                            spreadRadius:
                                                0.1, //extend the shadow
                                            offset: Offset(
                                              -5.0, // Move to right 5  horizontally
                                              10.0, // Move to bottom 5 Vertically
                                            ),
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.deepOrange,
                                        size: 130,
                                      )),
                                )
                              ],
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {

                             trainingProvider.set(trainings[0]) ;
                              Navigator.pushNamed(
                                  context, "/trainingDetailPage");
                            },
                            child: Container(
                              width: 250,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                                // color: Colors.yellow
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image.network(
                                  //     'https://img.youtube.com/vi/6cwnBBAVIwE/0.jpg'),
                                  // CachedNetworkImage(
                                  //   imageUrl: videoUrl,
                                  //   fit: BoxFit.cover,
                                  //   height: 200,
                                  //   width: double.infinity,
                                  // ),

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
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    child: Text(
                                      trainings[0].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      "Status: ${trainings[0].isCompleted ? 'Completed' : 'Not complete'}",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(int index) {
    switch (index) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';

      default:
        return '';
    }
  }
}

final appbarLogo = Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text(
      "Gym",
      style: TextStyle(color: Colors.deepOrange, fontSize: 20),
    ),
    Text(
      "Coach",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
  ],
);

AppBar appBar(context, title) {
  return AppBar(
    title: Text(title,style: TextStyle(color: Colors.black, fontSize: 20),),
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          CupertinoIcons.back,
          color: Colors.black,
        )),
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
