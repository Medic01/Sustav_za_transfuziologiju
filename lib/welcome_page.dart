import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/main.dart';
import 'package:sustav_za_transfuziologiju/user_home_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the first page!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to UserHomePage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage()),
                );
              },
              child: Text('Go to User Home'),
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
