import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/blood_donation_form.dart';

class Reservations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation Reservations'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('date_reservation_blood_donation')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('An error occurred: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Name: ${data['name']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${data['email']}'),
                    Text('Preferred Date: ${data['date']}'),
                    Text('Blood Type: ${data['blood_type']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BloodDonationForm(
                              date: data['date'],
                              donorName: data['name'],
                              bloodType: data['blood_type'],
                            ),
                          ),
                        ).then((_) {
                          // Nakon što korisnik spremi podatke u formu i vrati se
                          // u ovu komponentu, uklonite podatke iz baze podataka
                          FirebaseFirestore.instance
                              .collection('date_reservation_blood_donation')
                              .doc(document.id)
                              .delete()
                              .then((_) {
                            print('Document successfully deleted');
                          }).catchError((error) {
                            print('Error deleting document: $error');
                          });
                        });
                      },
                      child: Text('Accept'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Implementirajte logiku za odbijanje rezervacije
                      },
                      child: Text('Decline'),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
