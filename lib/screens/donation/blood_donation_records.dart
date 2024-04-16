import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/donation_tile.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/rejection_dialog.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dose_entry_page.dart';

class BloodDonationRecords extends StatelessWidget {
  final DonationService donationService = DonationService();

  BloodDonationRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.donationRecords),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blood_donation').snapshots(),
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
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return DonationTile(
                data: data,
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


  Future<void> _rejectDonation(BuildContext context, String documentId, Map<String, dynamic> data) async {
    String? rejectionReason = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => RejectionDialog(),
    );

    if (rejectionReason != null && rejectionReason.isNotEmpty) {
      await donationService.rejectDonation(documentId, rejectionReason);
      Navigator.of(context).pop();
    }
  }
}