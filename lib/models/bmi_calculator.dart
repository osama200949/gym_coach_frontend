import 'package:flutter/material.dart';

class BMICalculator {
  static const String underweightColor = "Under weight";
  static const String normalColor = "Normal";
  static const String overweightColor = "Over weight";
  static const String obeseColor = "Obesity";

  static double calculateBMI(double height, double weight) {
    // Convert height from cm to m
    height /= 100;

    // Calculate BMI
    double bmi = weight / (height * height);

    // Round BMI to two decimal places
    bmi = double.parse(bmi.toStringAsFixed(2));

    return bmi;
  }

  static String getBMIStateColor(double bmi) {
    if (bmi < 18.5) {
      return underweightColor;
    } else if (bmi < 25) {
      return normalColor;
    } else if (bmi < 30) {
      return overweightColor;
    } else {
      return obeseColor;
    }
  }
}
