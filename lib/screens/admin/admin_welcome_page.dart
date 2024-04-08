import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminWelcomePage extends StatefulWidget {
  @override
  _AdminWelcomePageState createState() => _AdminWelcomePageState();
}

class _AdminWelcomePageState extends State<AdminWelcomePage> {
  String _selectedFilter = 'Accepted';

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
            DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
              items: <String>['Accepted', 'Rejected'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _selectedFilter == 'Accepted'
                    ? FirebaseFirestore.instance.collection('accepted').snapshots()
                    : FirebaseFirestore.instance.collection('rejected').snapshots(),
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
                          if (_selectedFilter == 'Accepted') {
                            String donorName = document['donor_name'];
                            String bloodType = document['blood_type'];
                            //int? donatedAmount = document['donated_dose'];

                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text('Donor Name: $donorName'),
                                    Text('Blood Type: $bloodType'),

                                    Text('${AppLocalizations.of(context)!.donorName} $donorName'),
                                    Text('${AppLocalizations.of(context)!.bloodType} $bloodType'),

                                  ],
                                ),
                              ),
                            );
                          } else {
                            String name = document['donor_name'];
                            String bloodType = document['blood_type'];
                            String rejectionReason = document['reason_for_rejection'];

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