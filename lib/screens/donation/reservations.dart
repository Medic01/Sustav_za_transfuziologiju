import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/blood_donation_form.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/donation_status.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Reservations extends StatelessWidget {
  final DonationService _donationService = DonationService();
  final Logger logger = Logger("Reservations");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reservationTitle),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blood_donation')
            .where('status', isEqualTo: DonationStatus.PENDING.toString().split('.').last)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String,
                  dynamic>;

              if (data['status'] == DonationStatus.PENDING.toString().split('.').last) {
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
                          _handleAccept(context, document, data);
                        },
                        child: Text(AppLocalizations.of(context)!.acceptBtn),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _handleReject(context, document);
                        },
                        child: Text(AppLocalizations.of(context)!.rejectBtn),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  void _handleAccept(BuildContext context, DocumentSnapshot document, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BloodDonationForm(
              date: data['date'],
              donorName: data['donor_name'],
              bloodType: data['blood_type'],
              userId: data['user_id'],
              documentId: document.id,
              onAccept: (location, hemoglobin, bloodPressure, doctorName, technicianName) {
                _donationService.updateReservationAndAccept(
                  documentId: document.id,
                  location: location,
                  hemoglobin: hemoglobin,
                  bloodPressure: bloodPressure,
                  doctorName: doctorName,
                  technicianName: technicianName,
                ).then((_) {
                  logger.info('Reservation updated and accepted successfully');
                }).catchError((error) {
                  logger.severe('Error updating and accepting reservation: $error');
                });
              },
            ),
      ),
    );
  }

  void _handleReject(BuildContext context, DocumentSnapshot document) {
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
                _donationService.rejectDonation(document.id, rejectionReason).then((_) {
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
  }
}