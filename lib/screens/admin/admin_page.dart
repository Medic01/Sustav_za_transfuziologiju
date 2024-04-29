import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/main/main.dart';
import 'package:sustav_za_transfuziologiju/screens/admin/admin_welcome_page.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/dose_entry_page.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/reservations.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AdminWelcomePage(),
    Reservations(),
    DoseEntryPage(),
  ];

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                _onTappedItem(0);
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                _onTappedItem(1);
              },
            ),
            IconButton(
              icon: const Icon(Icons.book),
              onPressed: () {
                _onTappedItem(2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
