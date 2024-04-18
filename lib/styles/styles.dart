import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
final TextStyle appBarTextStyle = GoogleFonts.aDLaMDisplay(
  color: Colors.white,
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

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
final TextStyle emailErrorSnackBarTextStyle = TextStyle(color: Colors.white);
final Color emailErrorSnackBarBackgroundColor = Colors.red;
final TextStyle fillAllFieldsSnackBarTextStyle = TextStyle(color: Colors.white);
final Color fillAllFieldsSnackBarBackgroundColor = Colors.red;
