import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/models/training_coac.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/provider/training_coach_provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';

import '../../widgets/appbar.dart';

class CustomerChatScreen extends StatefulWidget {
  const CustomerChatScreen({Key? key}) : super(key: key);

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  DataService service = new DataService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true).get();
    final trainingCoachProvider =
        Provider.of<TrainingCoachProvider>(context, listen: false);
    print("user role= ${user.typeOfTraining}");

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        title: appbarLogo,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://roae-almasat.com/public/images/${user.image}"),
          ),
        ],
      ),
      body: FutureBuilder<List<TrainingCoach>>(
          future: service.getCoaches(
              token: user.token, typeOfTraining: user.typeOfTraining),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<TrainingCoach> data = snapshot.data as List<TrainingCoach>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  TrainingCoach coach = data[index];
                  return ListTile(
                    onTap: () {
                      trainingCoachProvider.set(coach);
                      Navigator.pushNamed(context, '/customerChatPage');
                    },
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          "https://roae-almasat.com/public/images/${coach.image}"),
                    ),
                    title: Text(coach.name),
                    subtitle: Text(coach.email),
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text('Failed to fetch data.'),
              );
            }
          }),
    );
  }
}
