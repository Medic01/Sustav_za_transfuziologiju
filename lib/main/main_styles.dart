import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final appBarStyle = TextStyle(
  color: Colors.red,
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

final buttonTextStyle = TextStyle(
  color: Colors.red,
);

final elevatedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.red,
  backgroundColor: Colors.white,
  side: const BorderSide(color: Colors.red, width: 2),
);

final textButtonTextStyle = TextStyle(
  color: Colors.red,
);

final textButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.white,
  side: const BorderSide(color: Colors.red, width: 2),
);
final BoxDecoration mainBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Colors.red,
    ],
  ),
);

final ThemeData mainTheme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
const paddingOnlyBottom20 = EdgeInsets.only(bottom: 20.0);
const container200Size = Size(200, 200);

const double standardPadding = 20.0;
const double littlePadding = 10.0;
