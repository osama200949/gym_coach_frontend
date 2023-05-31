import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/bmi_calculator.dart';
import 'package:todo_list/models/coach.dart';
import 'package:todo_list/models/training.dart';
import 'package:todo_list/models/training_coac.dart';
import 'package:todo_list/services/rest.dart';

import '../../models/customer.dart';
import '../../models/user.dart';
import '../../provider/user_provider.dart';
import '../../widgets/appbar.dart';

class CustomerLandingScreen extends StatelessWidget {
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
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "http://192.168.75.1/gym_coach/public/images/${user.image}"),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              // color: Colors.deepOrange,
              decoration: BoxDecoration(color: Colors.deepOrange),
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                user.name.substring(0, 1),
                                style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.userGroup),
                color: Colors.red,
                onPressed: () {
                  Navigator.pushNamed(context, '/customerActivityPage');
                },
              ),
              title: Text("Group activities"),
              onTap: () {
                Navigator.pushNamed(context, '/customerActivityPage');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                thickness: 2,
              ),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.trophy),
                color: Colors.red,
                onPressed: () {
                  Navigator.pushNamed(context, '/customerTrophyPage');
                },
              ),
              title: Text("Prizes"),
              onTap: () {
                Navigator.pushNamed(context, '/customerTrophyPage');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                thickness: 2,
              ),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onPressed: () {
                  service.logout(user.token);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              title: Text('Logout'),
              onTap: () {
                service.logout(user.token);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Welcome back, ${user.name}!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            MyComponent1(),
            MyComponent2(),
            // MyComponent3(),
            MyComponent4(),
          ],
        ),
      ),
    );
  }
}

class MyComponent1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataService service = DataService();
    final user = Provider.of<UserProvider>(context, listen: true).get();
    return Container(
      color: Color.fromARGB(255, 255, 242, 238),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Number of coaches',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Sorted by Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          FutureBuilder(
              future: service.getAllCoaches(token: user.token),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TrainingCoach> coaches =
                      snapshot.data as List<TrainingCoach>;

                  int numBodyBuilder = 0;
                  int numCalithnics = 0;
                  int numComperhansive = 0;
                  int numOthers = 0;
                  for (var i = 0; i < coaches.length; i++) {
                    if (coaches[i].typeOfTraining == "Body builder") {
                      numBodyBuilder++;
                    } else if (coaches[i].typeOfTraining == 'Calisthenics') {
                      numCalithnics++;
                    } else if (coaches[i].typeOfTraining == 'Comprehensive') {
                      numComperhansive++;
                    } else {
                      numOthers++;
                    }
                  }
                  double bodyBuilderPercentage =
                      numBodyBuilder / coaches.length;
                  double calithincisPercentage = numCalithnics / coaches.length;
                  double comperhensivePercentage =
                      numComperhansive / coaches.length;
                  double othersPercentage = numOthers / coaches.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Body builder'),
                                    SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: bodyBuilderPercentage,
                                      backgroundColor: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Calithnics'),
                                    SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: calithincisPercentage,
                                      backgroundColor: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('Comperhansive'),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: comperhensivePercentage,
                                  backgroundColor: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                Text('Others'),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: othersPercentage,
                                  backgroundColor: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}

class MyComponent2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataService service = DataService();
    final user = Provider.of<UserProvider>(context, listen: true).get();
    double bmi = BMICalculator.calculateBMI(user.height, user.weight);
    String bmiStatus = BMICalculator.getBMIStateColor(bmi);

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trainings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Trainings status by percentage',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          FutureBuilder(
              future: service.getCustomerTraining(
                  customerId: user.id, token: user.token),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  List<Training> trainings = snapshot.data as List<Training>;
                  int numCompleted = 0;
                  int numUncompleted = 0;
                  for (var i = 0; i < trainings.length; i++) {
                    if (trainings[i].isCompleted == 1) {
                      numCompleted++;
                    } else {
                      numUncompleted++;
                    }
                  }
                  double completedPercentage = numCompleted / trainings.length;
                  double uncompletedPercentage =
                      numUncompleted / trainings.length;

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Completed'),
                            SizedBox(height: 8),
                            CircularProgressIndicator(
                              value: completedPercentage,
                              backgroundColor: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Uncompleted'),
                            SizedBox(height: 8),
                            CircularProgressIndicator(
                              value: uncompletedPercentage,
                              backgroundColor: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BMI = ',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          '$bmi',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      ' $bmiStatus',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class MyComponent3 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserProvider>(context, listen: true).get();
//     DataService service = DataService();
//     return Container(
//       color: Color.fromARGB(255, 255, 242, 238),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Customers',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'List of ${user.typeOfTraining}',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           FutureBuilder(
//               future: service.getCustomers(
//                   token: user.token, typeOfTraining: user.typeOfTraining),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   List<Customer> customers = snapshot.data as List<Customer>;
//                   return Container(
//                     height: 200,
//                     child: ListView.builder(
//                       itemCount: customers.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           onTap: () {
//                             // customer2.set(data[index]);
//                             // Navigator.pushNamed(context, '/coachCustomerPage');
//                           },
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 "http://192.168.75.1/gym_coach/public/images/${customers[index].image}"),
//                           ),
//                           title: Text(customers[index].name),
//                           subtitle: Text(customers[index].email),
//                         );
//                       },
//                     ),
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               }),
//         ],
//       ),
//     );
//   }
// }

class MyComponent4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true).get();
    DataService service = DataService();
    return Container(
      color: Color.fromARGB(255, 255, 242, 238),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coaches',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'List of ${user.typeOfTraining}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          FutureBuilder(
              future: service.getCoaches(
                  token: user.token, typeOfTraining: user.typeOfTraining),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TrainingCoach> coaches =
                      snapshot.data as List<TrainingCoach>;
                  return Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: coaches.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            // customer2.set(data[index]);
                            // Navigator.pushNamed(context, '/coachCustomerPage');
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "http://192.168.75.1/gym_coach/public/images/${coaches[index].image}"),
                          ),
                          title: Text(coaches[index].name),
                          subtitle: Text(coaches[index].email),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}
