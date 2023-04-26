import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

AppBar AppBarWithNoBackBtn() {
  return AppBar(
    title: appbarLogo,
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
