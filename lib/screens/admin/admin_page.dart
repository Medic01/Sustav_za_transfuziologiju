import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/main.dart';
import 'package:sustav_za_transfuziologiju/screens/admin/admin_welcome_page.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/dose_entry_page.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/reservations.dart';


class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WELCOME ADMIN!'),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Reservations()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.book),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoseEntryPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout_rounded),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
