import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/models/customer.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';

import '../../provider/activity_provider.dart';
import '../../provider/customer_provider.dart';
import '../../widgets/appbar.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  DataService service = new DataService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true).get();
    final participants =
        Provider.of<ActivityProvider>(context, listen: true).getParticipants();

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
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {
          // Customer customer = data[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://roae-almasat.com/public/images/${participants[index].image}"),
            ),
            title: Text(participants[index].name),
            // trailing: Container(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      if (participants[index].points != 0) {
                        participants[index].points -= 50;
                      }
                      setState(() {});
                    },
                    icon: Icon(FontAwesomeIcons.minus,
                        size: 20, color: Colors.deepOrange),
                    color: Colors.white),
                Text("${participants[index].points}"),
                IconButton(
                    onPressed: () {
                      participants[index].points += 50;
                      setState(() {});
                    },
                    icon: Icon(Icons.add, color: Colors.deepOrange),
                    color: Colors.white),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn-1",
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text('Cancel')),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton.extended(
            heroTag: "btn-2",
              backgroundColor: Colors.white,
              onPressed: () async {
                service.uploadAllThePoints(participants, user.token);
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/coachActivityPage');
              },
              label: Text(
                'Submit all points',
                style: TextStyle(color: Colors.deepOrange),
              )),
        ],
      ),
    );
  }
}
