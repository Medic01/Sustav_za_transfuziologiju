import 'package:flutter/material.dart';

const columnCrossAxisAlignment = CrossAxisAlignment.stretch;
const rowMainAxisAlignment = MainAxisAlignment.spaceEvenly;
final doseProcessedButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: const BorderSide(color: Colors.red),
    ),
  ),
);
final doseUsedButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: const BorderSide(color: Colors.red),
    ),
  ),
);
const sizedBoxHeight = 8.0;
const checkMarkTextStyle = TextStyle(
  color: Colors.black,
);
const checkMarkIcon = Icon(Icons.check, color: Colors.green);