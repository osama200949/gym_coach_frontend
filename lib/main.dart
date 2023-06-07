import 'package:firebase_core/firebase_core.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/carousel.dart';
import 'package:todo_list/models/product.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/provider/activity_provider.dart';
import 'package:todo_list/provider/customer_provider.dart';
import 'package:todo_list/provider/training_coach_provider.dart';
import 'package:todo_list/provider/training_provider.dart';
import 'package:todo_list/provider/user_provider.dart';
import 'package:todo_list/provider/weekday_provider.dart';
import 'package:todo_list/screen/coach/add_new_activity.dart';
import 'package:todo_list/screen/coach/add_new_training.dart';
import 'package:todo_list/screen/coach/coach_activity.dart';
import 'package:todo_list/screen/coach/coach_activity_detail.dart';
import 'package:todo_list/screen/coach/coach_actual_chat.dart';
import 'package:todo_list/screen/coach/coach_evaluation.dart';
import 'package:todo_list/screen/coach/coach_training_detail.dart';
import 'package:todo_list/screen/customer/customer_activity.dart';
import 'package:todo_list/screen/customer/customer_activity_detail.dart';
import 'package:todo_list/screen/customer/customer_actual_chat.dart';
import 'package:todo_list/screen/coach/coach_home.dart';
import 'package:todo_list/screen/coach/coach_training.dart';
import 'package:todo_list/screen/customer/customer_home.dart';
import 'package:todo_list/screen/customer/customer_trophy.dart';
import 'package:todo_list/screen/register.dart';
import 'package:todo_list/screen/login.dart';
import 'package:todo_list/bin/customer_register.dart';
import 'package:todo_list/screen/test.dart';
import 'package:todo_list/screen/customer/customer_training_detail.dart';
import 'package:todo_list/widgets/create_bottom_sheet.dart';
import 'package:todo_list/widgets/edit_bottom_sheet.dart';
import 'package:todo_list/widgets/snackbar.dart';
import './services/rest.dart';
import 'package:image/image.dart' as image;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ActivityProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => TrainingProvider()),
      ChangeNotifierProvider(create: (context) => CustomerProvider()),
      ChangeNotifierProvider(create: (context) => WeekdayProvider()),
      ChangeNotifierProvider(create: (context) => TrainingCoachProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym coach',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/login',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.

        '/evaluationPage': (context) => EvaluationScreen(),
        '/activityDetailPage': (context) => CustomerActivityDetailScreen(),
        '/customerActivityPage': (context) => CustomerActivityScreen(),
        '/customerTrophyPage': (context) => CustomerTrophyScreen(),
        '/customerChatPage': (context) => CustomerActualChatScreen(),
        '/coachChatPage': (context) => CoachActualChatScreen(),
        '/login': (context) => LoginScreen(),
        // '/test': (context) => DropdownButtonApp(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        // '/home': (context) => const MyHomePage(
        //       title: 'Gym coach',
        //     ),
        '/addNewActivity': (context) => AddNewActivityScreen(),
        '/coachActivityPage': (context) => CoachActivityScreen(),
        '/coachActivityDetailPage': (context) => CoachActivityDetailScreen(),

        '/coachTrainingDetailPage': (context) => CoachTrainingDetailScreen(),
        '/trainingDetailPage': (context) => CustomerTrainingDetailsScreen(),
        '/addNewTraining': (context) => AddNewTrainingScreen(),
        '/coachCustomerPage': (context) => CoachCustomerScreen(),

        '/customerHomePage': (context) => const CustomerHomeScreen(),
        '/coachHomePage': (context) => const CoachHomeScreen(),
        '/customerRegister': (context) => RegisterScreen(
              role: 0,
            ),
        '/coachRegister': (context) => RegisterScreen(
              role: 1,
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataService service = DataService();
  List<Carousel> _carousels = [];
  List<Product> _products = [];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          // appBar: AppBar(title: Text("Welcome: " + user.get().name)),
          body: Column(
            children: [
              SafeArea(
                child: Container(
                  color: Colors.pink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Welcome ${user.get().name}",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () async {
                            //! Logout
                            bool response =
                                await service.logout(user.get().token);
                            if (response == true) {
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  displaySnackBar(text: "Failed to logout"));
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              TabBar(tabs: [
                Tab(
                  icon: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: Colors.pink,
                  ),
                ),
                Tab(
                  icon: Icon(Icons.view_carousel, color: Colors.pink),
                )
              ]),
              Expanded(
                child: TabBarView(children: [
                  _productTab(user.get()),
                  _carouselTab(user.get()),
                ]),
              )
            ],
          ),
        ));
  }

  FutureBuilder<List<Product>> _productTab(User user) {
    return FutureBuilder<List<Product>>(
      future: service.getProducts(user.token),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          _products = snapshot.data as List<Product>;
          final user = Provider.of<UserProvider>(context, listen: true);
          return _buildProductScreen(user.get());
        }
        return _buildFetchingDataScreen();
      }),
    );
  }

  Scaffold _buildProductScreen(User user) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await service.getCarousels(user.token);
          await service.getProducts(user.token);
          setState(() {});
        },
        child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      _products[index].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(_products[index].description),
                    trailing: Text("\$${_products[index].price}"),
                  ),
                  Divider(
                    thickness: 3,
                  )
                ],
              );
            }),
      ),
    );
  }

  FutureBuilder<List<Carousel>> _carouselTab(User user) {
    return FutureBuilder<List<Carousel>>(
      future: service.getCarousels(user.token),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          _carousels = snapshot.data as List<Carousel>;
          return _buildCarouselScreen(user);
        }
        return _buildFetchingDataScreen();
      }),
    );
  }

  Scaffold _buildCarouselScreen(User user) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await service.getCarousels(user.token);
          await service.getProducts(user.token);
          setState(() {});
        },
        child: ListView.builder(
            itemCount: _carousels.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  _carousels[index].image != null
                      ? ListTile(
                          title: Text(
                            _carousels[index].title,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(_carousels[index].description),
                          leading: Container(
                            width: 65,
                            height: 65,
                            child: Image.network(
                              "http://192.168.75.1/example-app/public/images/${_carousels[index].image}",
                            ),
                          ),
                          //! Delete
                          onLongPress: () {
                            service.deleteCarousel(
                                _carousels[index].id, user.token);
                          },

                          //! Edit
                          onTap: () {
                            editBottomSheet(
                                sheetContext: context,
                                carousel: _carousels[index]);
                          },
                        )
                      : ListTile(
                          title: Text(
                            _carousels[index].title,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(_carousels[index].description),
                          //! Delete
                          onLongPress: () {
                            service.deleteCarousel(
                                _carousels[index].id, user.token);
                          },
                          //! Edit
                          onTap: () {
                            editBottomSheet(
                                sheetContext: context,
                                carousel: _carousels[index]);
                          },
                        ),
                  Divider(
                    thickness: 3,
                  )
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          carouselBottomSheet(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Scaffold _buildFetchingDataScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Text('Fetching data... Please wait'),
          ],
        ),
      ),
    );
  }
}
