import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/provider/activity_provider.dart';
import 'package:todo_list/provider/training_provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/provider/weekday_provider.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar_with_no_back_btn.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/activity.dart';
import '../../models/customer.dart';
import '../../provider/customer_provider.dart';
import '../../widgets/appbar.dart';

class CustomerActivityScreen extends StatefulWidget {
  const CustomerActivityScreen({super.key});

  @override
  State<CustomerActivityScreen> createState() => _CustomerActivityScreenState();
}

class _CustomerActivityScreenState extends State<CustomerActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        title: appbarLogo,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Activity>>(
          future: service.getAllActivities(token: user.token),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Activity> activities = snapshot.data as List<Activity>;
              print(snapshot.data);
              return RefreshIndicator(
                onRefresh: () async {
                  await service.getAllActivities(token: user.token);
                  setState(() {});
                },
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    String originalDate = activities[index].date.toString();
                    int spaceIndex = originalDate.indexOf(' ');
                    String date = originalDate.substring(0, spaceIndex);
                    return InkWell(
                      onTap: () async {
                        activityProvider.set(activities[index]);
                        List<Customer> participants =
                            await service.getAllParticipants(
                                token: user.token,
                                activityId: activities[index].id.toString());
                        print(participants);
                        participants.forEach((element) {
                          if (element.id == user.id) {
                            activityProvider.setIsRegistered(true);
                            return;
                          } else {
                            activityProvider.setIsRegistered(false);
                          }
                        });
                        Navigator.pushNamed(context, "/activityDetailPage");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                            // color: Colors.yellow
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                child: Image.network(
                                  "https://roae-almasat.com/public/images/${activities[index].image}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: Text(
                                  activities[index].title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  "Date: ${date}",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  "Coach name: ${activities[index].coachName}",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

final appbarLogo = Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text(
      "Group activities",
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
