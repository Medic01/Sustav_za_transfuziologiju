import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistracijaPage extends StatefulWidget {
  @override
  _RegistracijaPageState createState() => _RegistracijaPageState();
}

class _RegistracijaPageState extends State<RegistracijaPage> {
  final TextEditingController _emailController = TextEditingController();
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
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    // Npr. prikaz poruke o uspješnoj registraciji ili navigacija na početnu stranicu
                  } catch (e) {
                    // Ako dođe do greške prilikom registracije, rukovanje greškom
                    print('Greška prilikom registracije: $e');
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
