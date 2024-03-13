import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:sustav_za_transfuziologiju/login.dart';
import 'dart:convert';

import 'package:sustav_za_transfuziologiju/user_role.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username (Email)'),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_usernameController.text.isNotEmpty ||
                      _passwordController.text.isNotEmpty) {
                    try {
                      final existingUser = await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: _usernameController.text)
                          .get();

                      if (existingUser.docs.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext contex) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('Username (Email) already exists!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            });
                      } else {
                        final passwordHash = sha256
                            .convert(utf8.encode(_passwordController.text))
                            .toString();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc()
                            .set({
                          'email': _usernameController.text,
                          'password': passwordHash,
                          'role': UserRole.USER.toString().split('.').last,
                        });

                        // Redirect logic to another page.. to login

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration successful!'),
                            duration: Duration(seconds: 3),
                          ),
                        );

                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        });
                      }
                    } catch (e) {
                      print("Error during registration $e");
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'Please enter username (email) and password.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        });
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
