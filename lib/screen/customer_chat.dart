import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';

class CustomerChatScreen extends StatefulWidget {
  const CustomerChatScreen({Key? key}) : super(key: key);

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  DataService service = new DataService();
  UserProvider user = new UserProvider();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coach>>(
        future: service.getCoaches(
            token: user.get().token, typeOfTraining: "Body builder"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<Coach> data = snapshot.data as List<Coach>;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Coach coach = data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "http://192.168.75.1/gym_coach/public/images/${coach.image}"),
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
        });
  }
}
