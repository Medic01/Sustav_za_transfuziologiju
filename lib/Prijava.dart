import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pocetna.dart'; // Pretpostavljam da postoji stranica PocetnaPage

class PrijavaPage extends StatefulWidget {
  @override
  _PrijavaPageState createState() => _PrijavaPageState();
}

class _PrijavaPageState extends State<PrijavaPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prijava'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    // Ako je prijava uspješna, navigiramo na početnu stranicu
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PocetnaPage()),
                    );
                  } catch (e) {
                    // Ako dođe do greške prilikom prijave, rukovanje greškom
                    print('Greška prilikom prijave: $e');
                  }
                },
                child: Text('Prijavi se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
