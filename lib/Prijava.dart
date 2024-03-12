import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/AdminPage.dart';

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
                        UserCredential userCredential =
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        // Provjeravamo korisničku ulogu nakon prijave
                        final user = userCredential.user;
                        if (user != null) {
                          // Dohvaćamo korisnički dokument iz Firestore-a
                          final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                          final role = userData.data()?['role'];
                          // Ako je korisnik administrator, navigiramo na početnu stranicu
                          if (role == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AdminPage()),
                            );
                          } else {
                            // Ako korisnik nije administrator, odjavljujemo ga
                            await _auth.signOut();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Prijava će vas odvesti ili na admin page ili na user page!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
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
