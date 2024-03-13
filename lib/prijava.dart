import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:sustav_za_transfuziologiju/admin_page.dart';

class PrijavaPage extends StatefulWidget {
  @override
  _PrijavaPageState createState() => _PrijavaPageState();
}

class _PrijavaPageState extends State<PrijavaPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Prijava'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Unesite svoj email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Unesite svoju lozinku';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        // Dohvatite podatke o korisniku iz Firestore-a
                        final userSnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: _emailController.text).get();
                        
                        if (userSnapshot.docs.isNotEmpty) {
                          final userData = userSnapshot.docs.first.data();
                          final storedPasswordHash = userData['password'];
                          
                          // Kriptirajte unesenu lozinku prije provjere
                          final passwordHash = generateHash(_passwordController.text);
                          
                          // Usporedite kriptirane lozinke
                          if (passwordHash == storedPasswordHash) {
                            final role = userData['role'];
                            if (role == 'ADMIN') {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Dobrodošao ADMIN!'),
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => AdminPage()),
                              );
                            } else if (role == 'USER') {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Dobrodošao USER!'),
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
                              // Ako korisnik nije administrator, odvedemo ga na stranicu običnog korisnika
                              /*Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => UserPage()),
                              );*/
                            }
                            return; // Izlaz iz funkcije nakon uspješne provjere
                          }
                        }
                        
                        // Lozinke se ne podudaraju ili korisnik nije pronađen, prikažite poruku o grešci
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pogrešno korisničko ime ili lozinka.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        // Ako dođe do greške prilikom prijave, rukovanje greškom
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Greška prilikom prijave: $e'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },

                  child: Text('Prijavi se'),
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
