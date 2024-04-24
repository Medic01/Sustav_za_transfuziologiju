import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/google_oauth/google_oauth.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/login/login_page.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/registration/registration_page.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/splash_screen/splash_screen.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/default_firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sustav_za_transfuziologiju/main/main_styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();

  try {
    await dotenv.load();
  } catch (e) {
    Logger.root.severe('Error loading .env file: $e');
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    Logger.root.severe('Error initializing Firebase: $e');

    return;
  }
  runApp(const MyApp());
}

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)?.appTitle ?? 'Donirajte krv :)',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: mainTheme,
      home: const SplashScreen(),
    );
  }
}

class MySvgWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/blood-drop-svgrepo-com.svg',
      semanticsLabel: 'My SVG Image',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger("HomePage");

    return Scaffold(
      appBar: AppBar(
        title: AnimatedDefaultTextStyle(
          style: appBarStyle,
          duration: const Duration(seconds: 1),
          child: Text(
            AppLocalizations.of(context)!.appTitle,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: mainBoxDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: paddingOnlyBottom20,
                child: Container(
                  width: container200Size.width,
                  height: container200Size.height,
                  child: MySvgWidget(),
                ),
              ),
              const SizedBox(height: standardPadding),
              ElevatedButton(
                onPressed: () {
                  logger.info("Registration button pressed!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.loginButton,
                  style: buttonTextStyle,
                ),
                style: elevatedButtonStyle,
              ),
              const SizedBox(height: littlePadding),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationPage()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.registrationButton,
                  style: textButtonTextStyle,
                ),
                style: textButtonStyle,
              ),
              const SizedBox(height: littlePadding),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GoogleOauth()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.oauth,
                  style: textButtonTextStyle,
                ),
                style: textButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
