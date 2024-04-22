import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//main
// Stil za AppBar Main
final appBarStyle = TextStyle(
  color: Colors.red,
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

// Stil za tekst u gumbima Main
final buttonTextStyle = TextStyle(
  color: Colors.red,
);

// Stil za gumb Main
final elevatedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.red,
  backgroundColor: Colors.white,
  side: const BorderSide(color: Colors.red, width: 2),
);

// Stil za tekst u TextButton Main
final textButtonTextStyle = TextStyle(
  color: Colors.red,
);

// Stil za TextButton Main
final textButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.white,
  side: const BorderSide(color: Colors.red, width: 2),
);
//main
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

//LOGIN izdvojeni stilovi
final TextStyle loginButtonTextStyle = TextStyle(color: Colors.white);
final ButtonStyle loginButtonStyle =
    ElevatedButton.styleFrom(backgroundColor: Colors.red);
final TextStyle passwordLabelStyle = TextStyle(color: Colors.red);
final Color visibilityIconColor = Colors.red;
final OutlineInputBorder inputBorder = OutlineInputBorder();
final Color appBarColor = Colors.red;
TextStyle appBarTextStyle = TextStyle(color: Colors.white);
// Login i register koriste
const double standardPadding = 20.0;
const double littlePadding = 10.0;
const double allSidesPadding = 20.0;

//REGISTRACIJA izdvojeni stilovi
final TextStyle snackBarTextStyle = TextStyle(color: Colors.white);
final Color snackBarBackgroundColor = Colors.green;
final TextStyle registrationButtonTextStyle = TextStyle(color: Colors.white);
final ButtonStyle registrationButtonStyle =
    ElevatedButton.styleFrom(backgroundColor: Colors.red);
final TextStyle usernameSnackBarTextStyle = TextStyle(color: Colors.white);
final Color usernameSnackBarBackgroundColor = Colors.red;
final TextStyle invalidPasswordSnackBarTextStyle =
    TextStyle(color: Colors.white);
final Color invalidPasswordSnackBarBackgroundColor = Colors.red;
final TextStyle passwordMismatchSnackBarTextStyle =
    TextStyle(color: Colors.white);
final Color passwordMismatchSnackBarBackgroundColor = Colors.red;
final TextStyle emailErrorSnackBarTextStyle =
    TextStyle(color: const Color.fromARGB(255, 44, 23, 23));
final Color emailErrorSnackBarBackgroundColor = Colors.red;
final TextStyle fillAllFieldsSnackBarTextStyle = TextStyle(color: Colors.white);
final Color fillAllFieldsSnackBarBackgroundColor = Colors.red;
final TextStyle validPasswordSnackBarTextStyle = TextStyle(color: Colors.white);
final Color validPasswordSnackBarBackgroundColor = Colors.green;
final TextStyle labelTextStyle = TextStyle(color: Colors.red);
final TextStyle appBarTitleTextStyle = TextStyle(color: Colors.white);
final Color appBarBackgroundColor = Colors.red;

const int passwordMinLength = 6;
const int passwordUppercaseCharCount = 1;
const int passwordNumericCharCount = 1;
const int passwordSpecialCharCount = 1;
const int passwordNormalCharCount = 3;
const double passwordValidatorWidth = 200.0;
const double passwordValidatorHeight = 100.0;

const MainAxisAlignment columnMainAxisAlignment = MainAxisAlignment.center;

//GoogleOauth izdvojeni stilovi
const appBarTitleStyle = TextStyle(color: Colors.white);
const materialButtonHeight = 50.0;
const materialButtonMinWidth = 200.0;
const materialButtonColor = Colors.red;
const materialButtonTextColor = Colors.white;
const sizedBoxHeight = 20.0;
const columnMainAxisAlignmentCenter = MainAxisAlignment.center;
const columnCrossAxisAlignment = CrossAxisAlignment.center;

//SplashScreen izdvojeni stilovi
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
