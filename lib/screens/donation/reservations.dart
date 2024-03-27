import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/blood_donation_form.dart';

class Reservations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakažite datum donacije krvi:'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('donation_date').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('An error occurred: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Name: ${data['donor_name']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${data['email']}'),
                    Text('Datum doniranja: ${data['date']}'),
                    Text('Krvna grupa: ${data['blood_type']}'),
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
                              donorName: data['donor_name'],
                              bloodType: data['blood_type'],
                              userId: data['user_id'],
                            ),
                          ),
                        ).then((_) {
                          FirebaseFirestore.instance
                              .collection('donation_date')
                              .doc(document.id)
                              .delete()
                              .then((_) {
                            print('Document successfully deleted');
                          }).catchError((error) {
                            print('Error deleting document: $error');
                          });
                        });
                      },
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String rejectionReason = '';

                            return AlertDialog(
                              title: const Text('Unesite razlog odbijanja: '),
                              content: TextField(
                                onChanged: (value) {
                                  rejectionReason = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Razlog obdijanja...',
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    String userId =
                                        data['user_id']; // Dohvaćanje userId-a

                                    FirebaseFirestore.instance
                                        .collection('rejected')
                                        .add({
                                      'donor_name': data['donor_name'],
                                      'email': data['email'],
                                      'date': data['date'],
                                      'blood_type': data['blood_type'],
                                      'reason_for_rejection': rejectionReason,
                                      'userId': userId, // Spremanje userId-a
                                    }).then((value) {
                                      print(
                                          'Declined donation added to declined_donations collection');
                                      FirebaseFirestore.instance
                                          .collection('donation_date')
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

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Decline'),
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
