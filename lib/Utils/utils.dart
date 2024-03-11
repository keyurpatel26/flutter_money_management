import 'package:flutter/material.dart';

class Utils {
  Size getScreenSize(context) {
    return MediaQuery.of(context).size;
  }
}

List history = [];
String username = "";
String profilepic = "";
double income = 0, expense = 0, total = income - expense;

