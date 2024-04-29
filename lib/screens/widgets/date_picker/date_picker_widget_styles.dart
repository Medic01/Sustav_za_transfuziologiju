import 'package:flutter/material.dart';

final datePickerThemeData = ThemeData.light().copyWith(
  colorScheme: ColorScheme.highContrastLight(
    primary: Colors.red,
  ),
  dialogBackgroundColor: Colors.white,
);
final inputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.red),
  border: OutlineInputBorder(),
);
