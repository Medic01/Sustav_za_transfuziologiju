import 'package:flutter/material.dart';

const headerTitleFontWeight = FontWeight.bold;
const headerTitleTextColor = Colors.white;
final headerBackgroundColor = Colors.red[900];
const donorNameFontWeight = FontWeight.bold;
const cardElevation = 3.0;
const cardMargin = EdgeInsets.all(8.0);
const containerColor = Colors.white;
final cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(16.0),
  side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
);
const crossAxisAlignment = CrossAxisAlignment.start;
const mainAxisAlignment = MainAxisAlignment.spaceBetween;
const containerPadding = EdgeInsets.all(12.0);
const containerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
    )
);
const buttonBarAlignment = MainAxisAlignment.spaceEvenly;
final acceptButtonStyle = ButtonStyle(backgroundColor:  MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.9)));
final rejectButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
  side: MaterialStateProperty.all(
      const BorderSide(color: Colors.red)
  ),
);
const acceptButtonTextColor = Colors.white;
const rejectButtonTextColor = Colors.black;
const svgHeight = 50.0;
const svgWidth = 50.0;