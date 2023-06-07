import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/services/rest.dart';

import '../../models/customer.dart';
import '../../provider/user_provider.dart';

class Winner {
  final String name;
  final int score;

  Winner(this.name, this.score);
}

class Trophy {
  final String title;
  final String description;
  final String image;

  Trophy(this.title, this.description, this.image);
}

class CustomerTrophyScreen extends StatelessWidget {
  List<Winner> winners = [
    Winner('John', 100),
    Winner('Emily', 95),
    Winner('Michael', 85),
  ];

  List<Trophy> trophies = [
    Trophy(
      'First Place',
      'Achieved the highest score',
      'assets/trophy1.jpg',
    ),
    Trophy(
      'Best Performance',
      'Consistently scored above 90',
      'assets/trophy2.jpg',
    ),
    Trophy(
      'Most Improved',
      'Showed significant progress',
      'assets/trophy3.jpg',
    ),
  ];

  bool isUser = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        title: appbarLogo,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Winners',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<Customer>>(
              future: service.getAllCustomers(token: user.token),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Customer> customers = snapshot.data as List<Customer>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          if (customers[index].id == user.id) {
                            isUser = true;
                          } else {
                            isUser = false;
                          }
                          return Card(
                            color: isUser
                                ? Color.fromARGB(255, 247, 221, 214)
                                : Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "http://192.168.75.1/gym_coach/public/images/${customers[index].image}"),
                              ),
                              title: Text(
                                customers[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Chip(
                                backgroundColor: Colors.green,
                                label: Text(
                                  '${customers[index].points}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Trophies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trophies.length,
                itemBuilder: (context, index) {
                  return Container(
                    // height: 100,
                    width: 250,
                    child: Card(
                      elevation: 1.0,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.network(
                            "http://192.168.75.1/gym_coach/public/images/${user.image}",
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trophies[index].title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  trophies[index].description,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 16.0),
                                OutlinedButton(
                                  onPressed: () {
                                    // Handle claim button click
                                    // You can add your logic here
                                  },
                                  child: Text('Claim'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final appbarLogo = Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text(
      "Scoreboard",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
  ],
);
