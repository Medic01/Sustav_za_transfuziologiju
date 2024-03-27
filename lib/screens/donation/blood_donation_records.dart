import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/donation_tile.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/rejection_dialog.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'dose_entry_page.dart';

class BloodDonationRecords extends StatelessWidget {
  final DonationService donationService = DonationService();

  BloodDonationRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donation Records'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blood_donation').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('An error occurred: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return DonationTile(
                data: data,
                onAccept: () async {
                  await _acceptDonation(context, document.id, data);
                },
                onReject: () async {
                  await _rejectDonation(context, document.id, data);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _acceptDonation(BuildContext context, String documentId, Map<String, dynamic> data) async {
    await donationService.acceptDonation(documentId, data);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const DoseEntryPage()));
  }

  Future<void> _rejectDonation(BuildContext context, String documentId, Map<String, dynamic> data) async {
    String? rejectionReason = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => RejectionDialog(),
    );

    if (rejectionReason != null && rejectionReason.isNotEmpty) {
      await donationService.rejectDonation(documentId, data, rejectionReason);
      Navigator.of(context).pop();
    }
  }
}