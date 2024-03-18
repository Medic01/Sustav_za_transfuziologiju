import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/blood_donation_records.dart';
import 'package:sustav_za_transfuziologiju/main.dart';
import '../donation/blood_donation_form.dart';
import '../user/user_home_page.dart';
import '../donation/dose_entry_page.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WELCOME ADMIN!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                'Welcome to the admin page!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage()),
                );
              },
              child: const Text('Go to Start Page'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BloodDonationForm()),
                );
              },
              child: const Text('Go to Blood Donation Form'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BloodDonationRecords()),
                );
              },
              child: const Text('Go to Blood Donation Records'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoseEntryPage()),
                );
              },
              child: const Text('Go to Record The Dose'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage()),
                );
              },
              child: const Text('Go to User Home Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        child: Icon(Icons.logout_rounded),
        backgroundColor: Colors.blue, // Promijenite boju gumba u plavu
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endDocked, // Postavite lokaciju gumba u desni donji kut
    );
  }
}
