import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:window_to_front/window_to_front.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthManager _authManager = AuthManager();

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
        throw Exception('Could not authenticate $error');
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
      throw Exception('Something went wrong');
    }
  }

  getCurrentUser() {}
}

class AuthManager {
  static const String revokeTokenUrl = 'https://oauth2.googleapis.com/revoke';

  Future<bool> signOutFromGoogle(String accessToken) async {
    final Uri uri = Uri.parse(revokeTokenUrl)
        .replace(queryParameters: {'token': accessToken});
    final http.Response response = await http.post(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  login() {}
}
