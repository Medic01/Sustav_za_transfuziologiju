import 'package:flutter/material.dart';
import 'korisnikPocetna.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prva stranica'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dobrodošli na prvu stranicu!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Navigacija na KorisnikPocetna
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KorisnikPocetna()),
                );
              },
              child: Text('Idi na Korisnik Pocetna'),
            ),
          ],
        ),
      ),
    );
  }
}
