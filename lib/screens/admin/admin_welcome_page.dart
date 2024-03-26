import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text('Admin Početna Stranica'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _selectedFilter == 'Accepted'
                    ? FirebaseFirestore.instance.collection('accepted').snapshots()
                    : FirebaseFirestore.instance.collection('rejected').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data!.docs[index];
                          if (_selectedFilter == 'Accepted') {
                            String donorName = document['donor_name'];
                            String bloodType = document['blood_type'];
                            int? donatedAmount = document['donated_dose'];

                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Donor Name: $donorName'),
                                    Text('Blood Type: $bloodType'),
                                    if (donatedAmount != null)
                                      Text('Donated Amount: $donatedAmount'),
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
                                    Text('Name: $name'),
                                    Text('Blood Type: $bloodType'),
                                    Text('Rejection Reason: $rejectionReason'),
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