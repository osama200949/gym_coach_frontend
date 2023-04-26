import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/models/customer.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';

class CoachChatScreen extends StatefulWidget {
  const CoachChatScreen({Key? key}) : super(key: key);

  @override
  State<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends State<CoachChatScreen> {
  DataService service = new DataService();
  @override
  Widget build(BuildContext context) {
 final user = Provider.of<UserProvider>(context, listen: true).get();
    print("user role= ${user.typeOfTraining}");
    
    return FutureBuilder<List<Customer>>(
        future: service.getCustomers(
            token: user.token, typeOfTraining: user.typeOfTraining)
            ,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<Customer> data = snapshot.data as List<Customer>;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Customer coach = data[index];
                return ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, '/chat');
                  },
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
