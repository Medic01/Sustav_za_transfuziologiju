import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/donation_list_item/donation_list_card.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/blood_types.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/donation_status.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/blood_drop_loading_widget/blood_drop_loading_widget.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dose_entry_lists_stlyes.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/blood_type_dropdown_widget/blood_type_dropdown_widget_sign.dart';

class DoseEntryLists extends StatefulWidget {
  const DoseEntryLists({Key? key}) : super(key: key);

  @override
  _DoseEntryListState createState() => _DoseEntryListState();
}

class _DoseEntryListState extends State<DoseEntryLists> {
  String? selectedBloodType;
  final DonationService _donationService = DonationService();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.acceptedBloodDonations,
          style: titleStyle,
        ),
        backgroundColor: titleBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: appBarPadding,
            child: buildDropdownButtonFormField(),
          ),
          Expanded(
            child: buildDonationList(),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButtonFormField() {
    return Container(
      decoration: dropdownBoxDecoration,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.chooseBloodType,
          contentPadding: dropdownContentPadding,
          border: const OutlineInputBorder(),
          labelStyle: dropDownTextFieldColor,
        ),
        value: selectedBloodType,
        onChanged: (String? newValue) {
          setState(() {
            selectedBloodType = newValue;
          });
        },
        items: BloodTypes.values.map((BloodTypes value) {
          String displayName = getBloodTypeDisplayName(value);
          return DropdownMenuItem<String>(
            value: value.toString().split('.').last,
            child: Text(displayName),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDonationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _donationService.getBloodDonationStream(
          DonationStatus.ACCEPTED,
          selectedBloodType: selectedBloodType
      ),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return BloodDropLoadingWidget();
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Card(
              elevation: cardElevation,
              margin: cardMargin,
              child: DonationListCard(
                data: data,
                documentId: document.id,
                donationService: _donationService,
                quantityController: quantityController,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}