import 'package:flutter/material.dart';

final titleBackgroundColor = Colors.red[900];
const bodyPadding = EdgeInsets.all(20.0);
const textStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
const sizedBoxHeight = 20.0;
const textFieldMargin = EdgeInsets.only(top: 10.0);
final inputDecorationBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: const BorderSide(color: Colors.red),
);
final buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
);
const buttonTextStyle = TextStyle(color: Colors.white);
const headerTextColor = TextStyle(color: Colors.white);
const labelTextStyle = TextStyle(color: Colors.red);
const icon = Icon(Icons.arrow_back);
const iconColor = Colors.white;