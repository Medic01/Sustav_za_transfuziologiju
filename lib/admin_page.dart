import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/bloodDonationRecords.dart';
import 'package:sustav_za_transfuziologiju/main.dart';
import 'dataOnBloodDonatioControl.dart';
import 'recordsOfDonations.dart';
import 'bloodDonationRecords.dart';
import 'recordTheDoze.dart';
import 'dataEntry.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WELCOME ADMIN!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the admin page!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage()),
                );
              },
              child: Text('Go to Start Page'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BloodDonationForm()),
                );
              },
              child: Text('Go to Blood Donation Form'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BloodDonationRecords()),
                );
              },
              child: Text('Go to Blood Donation Records'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordTheDoze()),
                );
              },
              child: Text('Go to Record The Doze'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage()),
                );
              },
              child: Text('Go to User Home Page'),
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
