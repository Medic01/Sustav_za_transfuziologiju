import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/blood_donation_form.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';

class Reservations extends StatelessWidget {
  final DonationService _donationService = DonationService();
  final Logger logger = Logger("Reservations");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakažite datum donacije krvi:'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('donation_date').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('An error occurred: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                          _donationService.acceptDonationAfterReservation(document.id, data).then((_) {
                            logger.info('Document successfully accepted after reservation');
                          }).catchError((error) {
                            logger.severe('Error accepting document after reservation: $error');
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
                                  hintText: 'Razlog odbijanja...',
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    String userId = data['user_id'];

                                    _donationService.rejectDonationAfterReservation(document.id, data, rejectionReason).then((_) {
                                      logger.info('Document successfully rejected after reservation');
                                    }).catchError((error) {
                                      logger.severe('Error rejecting document after reservation: $error');
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
                      child: const Text('Reject'),
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
