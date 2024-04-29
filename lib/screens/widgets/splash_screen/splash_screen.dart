import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sustav_za_transfuziologiju/main/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/splash_screen/splash_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: containerDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: columnMainAxisAlignmentCenter,
            children: <Widget>[
              SvgPicture.asset(
                'assets/blood-drop-svgrepo-com.svg',
                width: svgPictureWidth,
                height: svgPictureHeight,
              ),
              SizedBox(height: sizedBoxHeight),
              SizedBox(
                width: sizedBoxWidth,
                child: DefaultTextStyle(
                  style: defaultTextStyle,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        AppLocalizations.of(context)!.welcomeMessage,
                        duration: fadeAnimatedTextDuration,
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: animatedTextKitPause,
                    displayFullTextOnTap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
