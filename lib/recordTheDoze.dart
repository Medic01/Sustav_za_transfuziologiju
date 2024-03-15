import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordTheDoze extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted bloods'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('accepted').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('An error occurred: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              // Here you can format how you want to display the data from the document
              return ListTile(
                title: Text(
                    'blood_donation_location: ${data['blood_donation_location']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('date_od_donation: ${data['date_od_donation']}'),
                    Text(
                        'donor_blood_pressure ${data['donor_blood_pressure']}'),
                    Text('hemoglobin ${data['hemoglobin']}'),
                    Text('name_of_doctor ${data['name_of_doctor']}'),
                    Text('status ${data['status']}'),
                    Text(' user_id ${data['user_id']}'),
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
