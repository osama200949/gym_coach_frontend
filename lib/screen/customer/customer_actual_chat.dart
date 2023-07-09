import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/bin/coach_provider.dart';
import 'package:todo_list/provider/training_coach_provider.dart';
import 'dart:async';

import '../../models/message.dart';
import '../../provider/user_provider.dart';
import '../../widgets/appbar.dart';

class CustomerActualChatScreen extends StatefulWidget {
  const CustomerActualChatScreen({Key? key}) : super(key: key);

  @override
  State<CustomerActualChatScreen> createState() =>
      _CustomerActualChatScreenState();
}

class _CustomerActualChatScreenState extends State<CustomerActualChatScreen> {
  final Stream<QuerySnapshot> _chatStream =
      FirebaseFirestore.instance.collection('chat_messages').snapshots();
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<UserProvider>(context, listen: true).get();
    final coach =
        Provider.of<TrainingCoachProvider>(context, listen: true).get();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        title: Text(
          coach.name,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://roae-almasat.com/public/images/${coach.image}"),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _chatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Container(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      List<Message> messages = snapshot.data!.docs.map((doc) {
                        return Message(
                          text: doc['text'],
                          senderId: doc['senderId'],
                          receiverId: doc['receiverId'],
                          timestamp: doc['timestamp'] != null
                              ? (doc['timestamp'] as Timestamp)
                              : Timestamp.now(),
                        );
                      }).toList();
                      return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            Message message = messages[index];
                            bool isSentByCurrentUser =
                                message.senderId == customer.id.toString();

                            if (message.text == "") {
                              return Container();
                            }
                            if (isSentByCurrentUser &&
                                message.receiverId != coach.id.toString()) {
                              return Container();
                            }
                            if (message.senderId == customer.id.toString() ||
                                message.receiverId == coach.id.toString() ||
                                message.senderId == coach.id.toString()) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    SizedBox(height: 4.0),
                                    Text(
                                      DateFormat('dd/MM/yyyy, EEE, hh:mm a')
                                          .format(message.timestamp.toDate()),
                                      style: TextStyle(
                                        color: isSentByCurrentUser
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: isSentByCurrentUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: isSentByCurrentUser
                                                ? Colors.blue
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Text(
                                            message.text,
                                            style: TextStyle(
                                              color: isSentByCurrentUser
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Container();
                            }
                          });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration:
                              InputDecoration(hintText: 'Enter a message'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_textController.text != "") {
                            sendMessage(_textController.text,
                                customer.id.toString(), coach.id.toString());
                            _textController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void sendMessage(String text, String senderId, String receiverId) {
    FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
