import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class StreamDataWidget extends StatefulWidget {
  final String firstParam;
  final String secondParam;

  const StreamDataWidget(
      {required this.firstParam, required this.secondParam, Key? key})
      : super(key: key);

  @override
  State<StreamDataWidget> createState() => _StreamDataWidgetState();
}

class _StreamDataWidgetState extends State<StreamDataWidget> {
  final Stream<QuerySnapshot> _chatStream =
      FirebaseFirestore.instance.collection('chat_messages').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _chatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['message'] ?? ""),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Stream<http.Response> getDataStream() async* {
    final response = await http.get(Uri.parse(
        'http://192.168.0.103:8080/api/chats/${widget.firstParam}/${widget.secondParam}'));
    yield response;
  }
}
