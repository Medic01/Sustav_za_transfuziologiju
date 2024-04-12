import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/blood_types.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'donation_list_item.dart';

class DoseEntryPage extends StatefulWidget {
  const DoseEntryPage({Key? key}) : super(key: key);

  @override
  _DoseEntryPageState createState() => _DoseEntryPageState();
}

class _DoseEntryPageState extends State<DoseEntryPage> {
  String? selectedBloodType;
  final DonationService _donationService = DonationService();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.acceptedBloodDonations),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildDropdownButtonFormField(),
          const SizedBox(height: 8),
          Expanded(
            child: buildDonationList(),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButtonFormField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.chooseBloodType,
        border: const OutlineInputBorder(),
      ),
      value: selectedBloodType,
      onChanged: (String? newValue) {
        setState(() {
          selectedBloodType = newValue;
        });
      },
      items: BloodTypes.values.map((BloodTypes value) {
        return DropdownMenuItem<String>(
          value: value.toString().split('.').last,
          child: Text(value.toString().split('.').last),
        );
      }).toList(),
    );
  }

  Widget buildDonationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: selectedBloodType == 'All'
          ? FirebaseFirestore.instance.collection('blood_donation').where('status', isEqualTo: 'ACCEPTED').snapshots()
          : FirebaseFirestore.instance
          .collection('blood_donation')
          .where('status', isEqualTo: 'ACCEPTED')
          .where('blood_type', isEqualTo: selectedBloodType)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return DonationListItem(
              data: data,
              documentId: document.id,
              donationService: _donationService,
              quantityController: quantityController,
            );
          }).toList(),
        );
      },
    );
  }
}
