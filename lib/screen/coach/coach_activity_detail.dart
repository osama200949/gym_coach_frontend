import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/services/rest.dart';
import 'package:todo_list/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/customer.dart';
import '../../provider/activity_provider.dart';
import '../../provider/training_provider.dart';
import '../../provider/user_provider.dart';

class CoachActivityDetailScreen extends StatefulWidget {
  @override
  State<CoachActivityDetailScreen> createState() =>
      _CoachActivityDetailScreenState();
}

class _CoachActivityDetailScreenState extends State<CoachActivityDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isCompleted = false;
  bool _isEditing = false;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: true).get();
    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();

    isRegistered =
        Provider.of<ActivityProvider>(context, listen: true).getIsRegistered();

    String originalDate = activityProvider.date.toString();
    int spaceIndex = originalDate.indexOf(' ');
    String date = originalDate.substring(0, spaceIndex);

    return Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: Image.network(
                "https://roae-almasat.com/public/images/${activityProvider.image}",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coach: ${activityProvider.coachName}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Date: ${date}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    activityProvider.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  Text(
                    activityProvider.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "List of the participants:",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            FutureBuilder<List<Customer>>(
                future: service.getAllParticipants(
                    token: user.token,
                    activityId: activityProvider.id.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List<Customer> data = snapshot.data as List<Customer>;
                    Provider.of<ActivityProvider>(context, listen: false)
                        .setParticipants(data);
                    return Container(
                      height: 400,
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Customer customer = data[index];
                          return ListTile(
                            onTap: () {},
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://roae-almasat.com/public/images/${customer.image}"),
                            ),
                            title: Text(customer.name),
                            subtitle: Text(customer.email),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text('Failed to fetch data.'),
                    );
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: activityProvider.coachId == user.id
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/evaluationPage');
              },
              label: Text('Mark as complete'))
          : null,
    );
  }
}
