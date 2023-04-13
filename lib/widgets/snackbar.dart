import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SnackBar displaySnackBar({required String text}){
  return SnackBar(
      content: Text(text),
    );
}