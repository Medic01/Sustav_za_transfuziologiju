import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/google_oauth/auth_service.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/google_oauth/google_oauth_styles.dart';
import 'package:sustav_za_transfuziologiju/screens/user/data_entry_page/data_entry_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page/user_home_page.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleOauth extends StatefulWidget {
  const GoogleOauth({Key? key}) : super(key: key);

  @override
  State<GoogleOauth> createState() => _GoogleOauthState();
}

class _GoogleOauthState extends State<GoogleOauth> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger logger = Logger('GoogleOauth');
  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(context: context);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SessionManager sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.googleOauth,
          style: appBarTitleStyle,
        ),
        backgroundColor: appBarBackgroundColor,
        iconTheme: appBarIconTheme,
      ),
      body: _isLoggedIn
          ? Center(
              child: Column(
                mainAxisAlignment: columnMainAxisAlignment,
                crossAxisAlignment: columnCrossAxisAlignment,
                children: [
                  const SizedBox(height: sizedBoxHeight),
                  Text(_userObj.displayName ?? ''),
                  const SizedBox(height: sizedBoxHeight),
                  Text(_userObj.email),
                  const SizedBox(height: sizedBoxHeight),
                ],
              ),
            )
          : Center(
              child: MaterialButton(
                onPressed: _handleGoogleSignIn,
                height: materialButtonHeight,
                minWidth: materialButtonMinWidth,
                color: materialButtonColor,
                textColor: materialButtonTextColor,
                child: Text(AppLocalizations.of(context)!.oauthSignIn),
              ),
            ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        setState(() {
          _isLoggedIn = true;
          _userObj = googleUser;
        });

        final QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('userId', isEqualTo: _userObj.id)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          final userData = querySnapshot.docs.first.data();
          final isFirstLogin =
              (userData as Map<String, dynamic>)['is_first_login'] ?? true;

          if (isFirstLogin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DataEntryPage(
                  email: _userObj.email,
                ),
              ),
            );
          } else {
            sessionManager.setUserId(_userObj.id);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomePage(userData: {
                  'name': _userObj.displayName,
                  'email': _userObj.email,
                  'user_id': _userObj.id,
                }),
              ),
            );
          }
        } else {
          await _saveUserDataToFirestore(_userObj);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DataEntryPage(
                email: _userObj.email,
              ),
            ),
          );
        }
      }
    } catch (error) {
      logger.severe('Google oauth error sign in: $error');
    }
  }

  Future<void> _handleGoogleSignOut() async {
    try {
      await _googleSignIn.signOut();

      await _authService.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      setState(() {
        _isLoggedIn = false;
      });
    } catch (error) {
      logger.severe('Google oauth error sign up: $error');
    }
  }

  Future<void> _saveUserDataToFirestore(GoogleSignInAccount user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'displayName': user.displayName,
        'email': user.email,
        'userId': user.id,
      });
      sessionManager.setUserId(user.id);

      logger.info('User saved successfully!');
    } catch (error) {
      logger.severe('Error while saving user data $error');
    }
  }
}
