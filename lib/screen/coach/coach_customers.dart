import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/models/customer.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/services/rest.dart';

import '../../provider/customer_provider.dart';
import '../../widgets/appbar.dart';

class CoachCustomersScreen extends StatefulWidget {
  const CoachCustomersScreen({Key? key}) : super(key: key);

  @override
  State<CoachCustomersScreen> createState() => _CoachCustomersScreenState();
}

class _CoachCustomersScreenState extends State<CoachCustomersScreen> {
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
          // future: service.getCoaches(
          //     token: user.token, typeOfTraining: "Body builder")
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
                      customerProvider.set(data[index]);
                      Navigator.pushNamed(context, '/coachCustomerPage');
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
