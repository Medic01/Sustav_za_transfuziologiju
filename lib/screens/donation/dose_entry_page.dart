import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoseEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Blood Donations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('accepted').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: const Text('No data available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return buildListTile(context, data, document.id);
            },
          );
        },
      ),
    );
  }

  Widget buildListTile(BuildContext context, Map<String, dynamic> data, String documentId) {
    return ListTile(
      title: Text('Blood Donation Location: ${data['blood_donation_location']}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date of Donation: ${data['date_od_donation']}'),
          Text('Donor Blood Pressure: ${data['donor_blood_pressure']}'),
          Text('Hemoglobin: ${data['hemoglobin']}'),
          Text('Name of Doctor: ${data['name_of_doctor']}'),
          Text('Status: ${data['status']}'),
          Text('User ID: ${data['user_id']}'),
          // New options
          Text(
            'Doza Obradjena: ${data['dose_processed']}',
            style: TextStyle(
              color: data['dose_processed'] == true ? Colors.green : Colors.black,
            ),
          ),
          Text(
            'Doza Iskoristena: ${data['dose_used']}',
            style: TextStyle(
              color: data['dose_used'] == true ? Colors.green : Colors.black,
            ),
          ),
          Text(
            'Kolicina Donirane Doze: ${data['donated_blood_amount'] ?? 'N/A'}',
            style: TextStyle(
              color: data['donated_blood_amount'] == 100 ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 200,
        child: buildTrailingButtons(context, data, documentId),
      ),
    );
  }

  Widget buildTrailingButtons(BuildContext context, Map<String, dynamic> data, String documentId) {
    return SizedBox(
      height: 200, // Adjust the height as needed
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              markDoseAsProcessed(context, documentId);
            },
            child: Text('Oznaci kao obradjeno'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              markDoseAsUsed(context, documentId);
            },
            child: Text('Oznaci kao iskoristeno'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle showing dialog to enter dose quantity
            },
            child: Text('Unesi kolicinu'),
          ),
        ],
      ),
    );
  }


  void markDoseAsProcessed(BuildContext context, String documentId) {
    FirebaseFirestore.instance
        .collection('accepted')
        .doc(documentId)
        .update({'dose_processed': true})
        .then((_) => print('Dose processed'))
        .catchError((error) => print('Error processing dose: $error'));
  }

  void markDoseAsUsed(BuildContext context, String documentId) {
    FirebaseFirestore.instance
        .collection('accepted')
        .doc(documentId)
        .update({'dose_used': true})
        .then((_) => print('Dose used'))
        .catchError((error) => print('Error marking dose as used: $error'));
  }
}
