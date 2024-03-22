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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String declineReason =
                                ''; // Varijabla za pohranu razloga odbijanja

                            return AlertDialog(
                              title: Text('Enter Decline Reason'),
                              content: TextField(
                                onChanged: (value) {
                                  declineReason =
                                      value; // Ažuriranje razloga odbijanja kad korisnik unese nešto
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter reason here...',
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    // Spremi odbijenu donaciju u Firebase zajedno s razlogom
                                    FirebaseFirestore.instance
                                        .collection('declined_donations')
                                        .add({
                                      'name': data['name'],
                                      'email': data['email'],
                                      'date': data['date'],
                                      'blood_type': data['blood_type'],
                                      'reason_for_decline':
                                          declineReason, // Dodavanje razloga odbijanja
                                    }).then((value) {
                                      print(
                                          'Declined donation added to declined_donations collection');
                                      // Nakon što uspješno dodate odbijenu donaciju,
                                      // uklonite podatke iz baze podataka
                                      FirebaseFirestore.instance
                                          .collection(
                                              'date_reservation_blood_donation')
                                          .doc(document.id)
                                          .delete()
                                          .then((_) {
                                        print('Document successfully deleted');
                                      }).catchError((error) {
                                        print(
                                            'Error deleting document: $error');
                                      });
                                    }).catchError((error) {
                                      print(
                                          'Error adding declined donation: $error');
                                    });

                                    Navigator.of(context)
                                        .pop(); // Zatvaranje dijaloga nakon što korisnik pritisne gumb
                                  },
                                  child: Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
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
