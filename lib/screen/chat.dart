import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StreamDataWidget extends StatelessWidget {
  final String firstParam;
  final String secondParam;

  StreamDataWidget({required this.firstParam, required this.secondParam});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getDataStream(),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.hasData) {

          print(snapshot.data!.body);
          List data = [];
          final listJsonData = jsonDecode(snapshot.data!.body) ;
          for (var line in listJsonData) {
             Map item = line;
            data.add(item);
          }
          print(data.length);
          print(data[0]);
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(data[index]['message']);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Stream<http.Response> getDataStream() async* {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/chats/$firstParam/$secondParam'));
    yield response;
  }
}