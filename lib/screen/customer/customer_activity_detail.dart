import 'package:cached_network_image/cached_network_image.dart';
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

class CustomerActivityDetailScreen extends StatefulWidget {
  @override
  State<CustomerActivityDetailScreen> createState() =>
      _CustomerActivityDetailScreenState();
}

class _CustomerActivityDetailScreenState
    extends State<CustomerActivityDetailScreen>
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
            CachedNetworkImage(
              imageUrl:
                  "https://roae-almasat.com/public/images/${activityProvider.image}",
              imageBuilder: (context, imageProvider) => Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Todo: add new participant to the list.
          isRegistered
              ? await service.deleteParticipant(
                  token: user.token,
                  userId: user.id,
                  email: user.email,
                  activityId: activityProvider.id)
              : await service.addParticipant(
                  token: user.token,
                  userId: user.id,
                  email: user.email,
                  activityId: activityProvider.id);
          setState(() {
            isRegistered = !isRegistered;
            Provider.of<ActivityProvider>(context, listen: false)
                .setIsRegistered(isRegistered);
          });
        },
        backgroundColor: !isRegistered ? Colors.white : Colors.deepOrange,
        label: !isRegistered
            ? const Text(
                'Register',
                style: TextStyle(color: Colors.deepOrange),
              )
            : const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
        icon: !isRegistered
            ? const Icon(
                Icons.check_outlined,
                color: Colors.deepOrange,
              )
            : const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              ),
      ),
    );
  }
}
