import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sustav_za_transfuziologiju/screens/auth/auth_service.dart';
import 'package:window_to_front/window_to_front.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleOauth extends StatefulWidget {
  const GoogleOauth({Key? key}) : super(key: key);

  @override
  State<GoogleOauth> createState() => _GoogleOauthState();
}

class _GoogleOauthState extends State<GoogleOauth> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  final AuthService _authService = AuthService();
  final AuthManager _authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google OAuth'),
      ),
      body: _isLoggedIn
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_userObj.photoUrl ?? ''),
                    radius: 50,
                  ),
                  const SizedBox(height: 20),
                  Text(_userObj.displayName ?? ''),
                  const SizedBox(height: 20),
                  Text(_userObj.email),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleGoogleSignOut,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: const Size(100, 50),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            )
          : Center(
              child: MaterialButton(
                onPressed: _handleGoogleSignIn,
                height: 50,
                minWidth: 200,
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('Sign in with Google'),
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
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<void> _handleGoogleSignOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() {
        _isLoggedIn = false;
      });
      String? token;
      final user = _authService.getCurrentUser();
      if (user != null) {
        final idToken = await user.getIdToken();
        token = idToken;
      }
      await _authManager.signOutFromGoogle(token!);
    } catch (error) {
      print('Error signing out with Google: $error');
    }
  }
}
