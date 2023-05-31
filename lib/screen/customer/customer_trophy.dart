import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/widgets/appbar.dart';

class CustomerTrophyScreen extends StatefulWidget {
  const CustomerTrophyScreen({super.key});

  @override
  State<CustomerTrophyScreen> createState() => _CustomerTrophyScreenState();
}

class _CustomerTrophyScreenState extends State<CustomerTrophyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events, // Trophy icon
              size: 150,
              color: Colors.amber,
            ),
            SizedBox(height: 16),
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You have won the trophy!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Perform an action when the button is pressed
              },
              child: Text('Claim Prize'),
            ),
          ],
        ),
      ),
    );
  }
}