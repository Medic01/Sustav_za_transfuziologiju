import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:sustav_za_transfuziologiju/prijava.dart';
import 'dart:convert';

import 'package:sustav_za_transfuziologiju/user_role.dart';

class RegistracijaPage extends StatefulWidget {
  @override
  _RegistracijaPageState createState() => _RegistracijaPageState();
}

class _RegistracijaPageState extends State<RegistracijaPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registracija'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Korisničko ime (Email)'
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Lozinka',
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_usernameController.text.isNotEmpty || _passwordController.text.isNotEmpty) {
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
                              title: Text('Greška'),
                              content: Text('Korisničko ime (Email) već postoji!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          }
                        );
                      } else {
                        final passwordHash = sha256
                            .convert(utf8.encode(_passwordController.text))
                            .toString();
                        await FirebaseFirestore.instance.collection('users').doc().set({
                          'email': _usernameController.text,
                          'password': passwordHash,
                          'role': UserRole.USER.toString().split('.').last,
                        });

                        //logika preusmjeravanja na drugu stranicu.. na login

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Uspješno ste se registrirali!'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => PrijavaPage()),
                          );
                        });
                      }
                    } catch (e) {
                      print("Greška prilikom registracije $e");
                    }
                  } else {
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Greška'),
                          content: Text('Unesite korisničko ime (email) i lozinku.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      }
                    );
                  }
                },
                child: Text('Registrirajte se'),
                ),
            ],
          ),
        ),
      ),

    );
  }
}
