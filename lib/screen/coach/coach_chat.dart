import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/customer.dart';
import 'package:todo_list/provider/customer_provider.dart';
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
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
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
                "http://192.168.75.1/gym_coach/public/images/${user.image}"),
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
          future: service.getCustomers(
              token: user.token, typeOfTraining: user.typeOfTraining),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<Customer> data = snapshot.data as List<Customer>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Customer customer = data[index];
                  return ListTile(
                    onTap: () {
                      customerProvider.set(customer);
                      Navigator.pushNamed(context, '/coachChatPage');
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "http://192.168.75.1/gym_coach/public/images/${customer.image}"),
                    ),
                    title: Text(customer.name),
                    subtitle: Text(customer.email),
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
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
