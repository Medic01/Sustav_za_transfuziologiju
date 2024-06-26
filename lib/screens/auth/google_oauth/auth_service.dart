import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:sustav_za_transfuziologiju/services/oauth_constants.dart';
import 'package:window_to_front/window_to_front.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthManager _authManager = AuthManager();
  final BuildContext context;

  AuthService({required this.context});

  Future<User?> signInWithGoogle() async {
    User? user;

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      Credentials credentials = await _authManager.login();

      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: credentials.idToken, accessToken: credentials.accessToken);

      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(authCredential);
        user = userCredential.user;
      } on FirebaseAuthException catch (error) {
        throw Exception(
            '${AppLocalizations.of(context)!.oauthAuthenticateError} $error');
      }
    }

    return user;
  }

  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      String? token;
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        final AuthManager _desktopAuthManager = AuthManager();
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final idToken = await user.getIdToken();
          token = idToken;
        }
        await _desktopAuthManager.signOutFromGoogle(token!);
      }
      await auth.signOut();
    } on Exception {
      throw Exception(AppLocalizations.of(context)!.oauthSomethingWrong);
    }
  }

  getCurrentUser() {}
}

class AuthManager {
  String revokeUrl = Constants.revokeTokenUrl;

  Future<bool> signOutFromGoogle(String accessToken) async {
    final Uri uri =
        Uri.parse(revokeUrl).replace(queryParameters: {'token': accessToken});
    final http.Response response = await http.post(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  login() {}
}
