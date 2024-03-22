import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/main.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/blood_donation_reservation_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState () => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget> [
    UserHomePage(),
    BloodDonationReservationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_pages.elementAt(_selectedIndex),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {
                _onItemTapped(0);
              },
              icon: const Icon(Icons.home),
            ),

            IconButton(
              onPressed: () {
                _onItemTapped(1);
              },
              icon: const Icon(Icons.calendar_today),
            ),

            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
