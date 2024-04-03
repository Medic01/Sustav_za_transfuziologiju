import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:sustav_za_transfuziologiju/screens/admin/admin_page.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/user_role.dart';
import 'package:sustav_za_transfuziologiju/screens/user/data_entry_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/welcome_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SessionManager sessionManager = SessionManager();

  bool _isPasswordVisible = false;
  Map<String, dynamic>? _loggedInUserData;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Korisničko ime (Email)',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Unesite vaš email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Unesite vašu lozinku';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final userSnapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: _emailController.text)
                            .get();

                        if (userSnapshot.docs.isNotEmpty) {
                          final userData = userSnapshot.docs.first.data();
                          final storedPasswordHash = userData['password'];

                          sessionManager.setUserId(userData['user_id']);

                          final passwordHash =
                              generateHash(_passwordController.text);

                          if (passwordHash == storedPasswordHash) {
                            setState(() {
                              _loggedInUserData = userData;
                            });

                            final role = userData['role'];
                            final isFirstLogin =
                                userData['is_first_login'] ?? true;
                            print(isFirstLogin);

                            if (role == UserRole.ADMIN) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Welcome ADMIN!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WelcomePage()
                                              ),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AdminPage()
                                ),
                              );
                            } else if (role == UserRole.USER) {
                              if (isFirstLogin) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DataEntryPage(
                                            email: _emailController.text,
                                          )
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserHomePage(
                                          userData: _loggedInUserData)
                                  ),
                                );
                              }
                            }
                            return;
                          }
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Incorrect email or password.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login failed: $e'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String generateHash(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}
