import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/donation_status.dart';

class AdminWelcomePage extends StatefulWidget {
  @override
  _AdminWelcomePageState createState() => _AdminWelcomePageState();
}

class _AdminWelcomePageState extends State<AdminWelcomePage> {
  DonationStatus _selectedFilter = DonationStatus.ACCEPTED;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homePageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0),
            DropdownButton<DonationStatus>(
              value: _selectedFilter,
              onChanged: (DonationStatus? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
              items: [
                DonationStatus.ACCEPTED,
                DonationStatus.REJECTED,
              ].map((DonationStatus value) {
                return DropdownMenuItem<DonationStatus>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('blood_donation')
                    .where('status', isEqualTo: _selectedFilter.toString().split('.').last)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data!.docs[index];
                          if (_selectedFilter == DonationStatus.ACCEPTED) {
                            String donorName = document['donor_name'];
                            String bloodType = document['blood_type'];

                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${AppLocalizations.of(context)!.donorName} $donorName'),
                                    Text('${AppLocalizations.of(context)!.bloodType} $bloodType'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            String name = document['donor_name'];
                            String bloodType = document['blood_type'];
                            String rejectionReason = document['rejection_reason'];

                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${AppLocalizations.of(context)!.donorName} $name'),
                                    Text('${AppLocalizations.of(context)!.bloodType} $bloodType'),
                                    Text('${AppLocalizations.of(context)!.rejectionReason} $rejectionReason'),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}