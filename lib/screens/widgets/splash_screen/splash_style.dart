import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const backgroundColor = Colors.white;
const containerDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Colors.red,
    ],
  ),
);

const svgPictureWidth = 150.0;
const svgPictureHeight = 150.0;

const sizedBoxWidth = 250.0;
const defaultTextStyle = TextStyle(
  fontSize: 50.0,
  color: Colors.white,
);
const fadeAnimatedTextDuration = Duration(milliseconds: 4000);
const animatedTextKitPause = Duration(milliseconds: 1000);
const columnMainAxisAlignmentCenter = MainAxisAlignment.center;
const sizedBoxHeight = 20.0;
