import 'package:flutter/material.dart';
import 'pocetna.dart';
import 'evidencija_dolazaka.dart';
import 'korisnikPocetna.dart';

class AdminPage extends StatelessWidget {
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigacija na PocetnaPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PocetnaPage()),
                );
              },
              child: Text('Idi na Početnu stranicu'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Navigacija na EvidencijaDolazakaPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BloodDonationForm()),
                );
              },
              child: Text('Idi na Evidenciju dolazaka'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Navigacija na EvidencijaDolazakaPage
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
