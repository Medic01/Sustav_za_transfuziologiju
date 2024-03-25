import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/registration_page.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/reservations.dart';
import 'package:sustav_za_transfuziologiju/screens/user/blood_donation_reservation_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/welcome_page.dart';

class UserHomePage extends StatelessWidget {
  final Map<String, dynamic>? userData;

  UserHomePage({this.userData});

  @override
  Widget build(BuildContext context) {
    final String userEmail = userData != null ? userData!['email'] : '';
    final String userId = userData != null ? userData!['userId'] : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('User Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome, ${userData != null ? userData!['name'] : 'Unknown'}!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Email: $userEmail',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: userEmail)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('An error occurred: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No user data found.'));
                }

                final userData =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('accepted')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('An error occurred: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No accepted data found.'));
                    }

                    final acceptedData = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();

                    return ListView.builder(
                      itemCount: acceptedData.length,
                      itemBuilder: (context, index) {
                        final entry = acceptedData[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: entry.entries
                              .map((entry) => ListTile(
                                    title: Text(entry.key),
                                    subtitle: Text(entry.value.toString()),
                                  ))
                              .toList(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {
                // Navigacija na početnu stranicu korisnika
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BloodDonationReservationPage()),
                );
              },
              icon: const Icon(Icons.calendar_today),
            ),
            IconButton(
              onPressed: () {
                // Navigacija na početnu stranicu aplikacije
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
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
