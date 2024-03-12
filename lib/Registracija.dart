import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RegistracijaPage extends StatefulWidget {
  @override
  _RegistracijaPageState createState() => _RegistracijaPageState();
}

class _RegistracijaPageState extends State<RegistracijaPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  labelText: 'Korisničko ime (Email)',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Lozinka',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // Provjeri je li korisničko ime (email) i lozinka uneseni
                  if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                    try {
                      // Provjeri je li email već u upotrebi
                      final existingUser = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: _usernameController.text).get();
                      if (existingUser.docs.isNotEmpty) {
                        // Ako email već postoji, prikaži poruku o grešci
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Greška'),
                              content: Text('Korisničko ime (email) već postoji.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Hashiraj lozinku
                        final passwordHash = sha256.convert(utf8.encode(_passwordController.text)).toString();
                        
                        // Spremi korisničke podatke u Firestore
                        await FirebaseFirestore.instance.collection('users').doc().set({
                          'email': _usernameController.text,
                          'lozinka': passwordHash,
                          'uloga': 'korisnik',
                        });

                        // Nakon uspješne registracije, možemo navigirati korisnika na sljedeću stranicu
                        // Ovdje bi bila logika za preusmjeravanje na odgovarajuću stranicu, ovisno o ulozi korisnika
                      }
                    } catch (e) {
                      // Ako dođe do greške prilikom registracije, rukovanje greškom
                      print('Greška prilikom registracije: $e');
                    }
                  } else {
                    // Ako korisničko ime (email) i lozinka nisu uneseni, prikaži poruku o grešci
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
                      },
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
