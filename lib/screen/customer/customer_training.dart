import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/provider/training_provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/provider/weekday_provider.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar_with_no_back_btn.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/customer_provider.dart';
import '../../widgets/appbar.dart';

class CustomerTrainingScreen extends StatefulWidget {
  const CustomerTrainingScreen({super.key});

  @override
  State<CustomerTrainingScreen> createState() => _CustomerTrainingScreenState();
}

class _CustomerTrainingScreenState extends State<CustomerTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    final trainingProvider =
        Provider.of<TrainingProvider>(context, listen: false);
    // final customer = Provider.of<CustomerProvider>(context, listen: true).get();
    final user = Provider.of<UserProvider>(context, listen: true).get();
    final weekday = Provider.of<WeekdayProvider>(context, listen: false);
    DataService service = DataService();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        title: appbarLogo,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "http://192.168.75.1/gym_coach/public/images/${user.image}"),
          ),
        ],
      ),
      body: FutureBuilder<List<Training>>(
          future: service.getCustomerTraining(
              customerId: user.id, token: user.token),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              List<Training> trainings = snapshot.data as List<Training>;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < 7; i++)
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
                            height: 250,
                            // color: Colors.red,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: trainings.length,
                              itemBuilder: (context, index) {
                                String videoId = YoutubePlayer.convertUrlToId(
                                    trainings[index].video as String) as String;
                                String incomingDay = trainings[index].day;

                                if (incomingDay == _getWeekdayName(i)) {
                                  return InkWell(
                                    onTap: () {
                                      trainingProvider.set(trainings[index]);
                                      Navigator.pushNamed(
                                          context, "/trainingDetailPage");
                                    },
                                    child: Container(
                                      width: 250,
                                      margin: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        // color: Colors.yellow
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          YoutubePlayerBuilder(
                                            player: YoutubePlayer(
                                              controller:
                                                  YoutubePlayerController(
                                                initialVideoId:
                                                    videoId as String,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 0, 0),
                                            child: Text(
                                              trainings[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 0, 0),
                                            child: Text(
                                              "Status: ${trainings[index].isCompleted == 1 ? 'Completed' : 'Not complete'}",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 0, 0),
                                            child: Text(
                                              "Coach name: ${trainings[index].coachName}",
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
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
    title: Text(
      title,
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
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
