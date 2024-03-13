import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Home'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('kontrola_darivanja')
            .snapshots(),
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
                title: Text('Date: ${data['date']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location: ${data['location']}'),
                    Text('Doctor\'s name: ${data['doctor_name']}'),
                    Text('Technician\'s name: ${data['technician_name']}'),
                    Text('Blood pressure: ${data['blood_pressure']}'),
                    Text('Donation rejected: ${data['donation_rejected']}'),
                    Text('Rejection reason: ${data['rejection_reason']}'),
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
