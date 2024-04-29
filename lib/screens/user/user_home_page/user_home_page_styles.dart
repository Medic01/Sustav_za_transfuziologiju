import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const welcomeTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const sizedBoxHeightSmall = 10.0;
const emailTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);
Widget testTubeSvg() {
  return SvgPicture.asset(
    'assets/test-tube-svgrepo-com.svg',
    width: 20,
    height: 20,
  );
}

const errorTextStyle = TextStyle(
  color: Colors.red,
);
Widget noDonationSvg() {
  return SvgPicture.asset(
    'assets/nema-donacija.svg',
    width: 100,
    height: 100,
  );
}

const noDataTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);
const containerMargin = EdgeInsets.all(20.0);
const containerPadding = EdgeInsets.all(20.0);
final boxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3),
    ),
  ],
);

const titleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const subtitleTextStyle = TextStyle(
  color: Colors.black,
);
const mainAxisAlign = MainAxisAlignment.spaceAround;
const sizedBoxHeight = 20.0;
const appBarTitleStyle = TextStyle(color: Colors.white);
final Color appBarBackgroundColor = Colors.red;
