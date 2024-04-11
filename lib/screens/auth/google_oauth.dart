import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/auth_service.dart';
import 'package:sustav_za_transfuziologiju/screens/user/data_entry_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';
import 'package:sustav_za_transfuziologiju/services/databse_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  SessionManager sessionManager = SessionManager();

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

        final QuerySnapshot querySnapshot =
            await _databaseHelper.getUserById(_userObj.id);
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
      print('Error signing in with Google: $error');
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
      print('Error signing out: $error');
    }
  }

  Future<void> _saveUserDataToFirestore(GoogleSignInAccount user) async {
    try {
      await _databaseHelper.saveUserToFirestore(user);
      sessionManager.setUserId(user.id);

      print('User data saved to Firestore');
    } catch (error) {
      print('Error saving user data to Firestore: $error');
    }
  }
}
