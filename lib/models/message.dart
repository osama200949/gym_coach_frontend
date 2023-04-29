import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  String text;
  String senderId;
  String receiverId;
  Timestamp timestamp;

  Message(
      {required this.text,
      required this.senderId,
      required this.receiverId,
      required this.timestamp});
}
