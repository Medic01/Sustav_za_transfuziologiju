import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dose_entry_page.dart';

class BloodDonationRecords extends StatelessWidget {
  const BloodDonationRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donation Records'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('blood_donation').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('An error occurred: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              // Here you can format how you want to display the data from the document
              return ListTile(
                title: Text('Mjesto doniranja: ${data['location']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datum donacije: ${data['date']}'),
                    Text('Tlak darivatelja ${data['blood_pressure']}'),
                    Text('Hemoglobin ${data['hemoglobin']}'),
                    Text('Ime doktora ${data['doctor_name']}'),
                    Text('Krvna grupa darivatelja: ${data['blood_type']}'),
                    Text('Ime darivatelja: ${data['donor_name']}'),
                    Text('Ime tehničara: ${data['technician_name']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        CollectionReference bloodDonationRef = FirebaseFirestore
                            .instance
                            .collection('blood_donation');
                        CollectionReference acceptedRef =
                            FirebaseFirestore.instance.collection('accepted');
                        acceptedRef.add({
                          'location': data['location'],
                          'date': data['date'],
                          'blood_pressure': data['blood_pressure'],
                          'hemoglobin': data['hemoglobin'],
                          'doctor_name': data['doctor_name'],
                          'blood_type': data['blood_type'],
                          'user_id': data['user_id'],
                          'donor_name': data['donor_name'],
                        }).then((value) {
                          bloodDonationRef
                              .doc(document.id)
                              .delete();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DoseEntryPage()),
                          );
                        }).catchError((error) {
                          print('Error adding document to accepted collection: $error');});
                      },
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String rejectionReason = '';

                            return AlertDialog(
                              title: const Text('Unesite razlog odbijanja: '),
                              content: TextField(
                                onChanged: (value) {
                                  rejectionReason = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Razlog...',
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('rejected')
                                        .add({
                                      'location': data['location'],
                                      'date_od_donation': data['date_od_donation'],
                                      'blood_pressure': data['blood_pressure'],
                                      'hemoglobin': data['hemoglobin'],
                                      'doctor_name': data['doctor_name'],
                                      'blood_type': data['blood_type'],
                                      'user_id': data['user_id'],
                                      'donor_name': data['donor_name'],
                                      'reason_for_rejection': rejectionReason,
                                    }).then((value) {
                                      print('Odbijena donacija dodana u kolekciju rejected');
                                      FirebaseFirestore.instance
                                          .collection('blood_donation')
                                          .doc(document.id)
                                          .delete()
                                          .then((_) {
                                        print('Dokument uspješno obrisan');
                                      }).catchError((error) {
                                        print('Greška pri brisanju dokumenta: $error');
                                      });

                                      Navigator.of(context).pop();
                                    }).catchError((error) {
                                      print('Greška pri dodavanju odbijene donacije: $error');
                                    });
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Decline'),
                    ),
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
