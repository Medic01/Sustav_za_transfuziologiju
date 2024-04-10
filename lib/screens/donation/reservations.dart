import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/blood_donation_form.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Reservations extends StatelessWidget {
  final DonationService _donationService = DonationService();
  final Logger logger = Logger("Reservations");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.donationDateReservation),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('donation_date').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${AppLocalizations.of(context)!.donorName} ${data['donor_name']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppLocalizations.of(context)!.emailTxt} ${data['email']}'),
                    Text('${AppLocalizations.of(context)!.donationDate} ${data['date']}'),
                    Text('${AppLocalizations.of(context)!.bloodType} ${data['blood_type']}'),
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
                              title: Text(AppLocalizations.of(context)!.rejection),
                              content: TextField(
                                onChanged: (value) {
                                  rejectionReason = value;
                                },
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.rejectionReason,
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
                                  child: Text(AppLocalizations.of(context)!.submitBtn),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.rejectBtn),
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
