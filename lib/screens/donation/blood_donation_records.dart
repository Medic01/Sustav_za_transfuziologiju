import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dose_entry_page.dart';

class BloodDonationRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation Records'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('blood_donation').snapshots(),
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
                    Text('blood_type: ${data['blood_type']}'),
                    Text('donor_name: ${data['donor_name']}'),
                    Text('Tehnician Name: ${data['technicianName']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Stvaranje referenci za dokumente
                        CollectionReference bloodDonationRef = FirebaseFirestore
                            .instance
                            .collection('blood_donation');
                        CollectionReference acceptedRef =
                            FirebaseFirestore.instance.collection('accepted');
                        // Stvaranje novog dokumenta u kolekciji "accepted"
                        acceptedRef.add({
                          'blood_donation_location':
                              data['blood_donation_location'],
                          'date_od_donation': data['date_od_donation'],
                          'donor_blood_pressure': data['donor_blood_pressure'],
                          'hemoglobin': data['hemoglobin'],
                          'name_of_doctor': data['name_of_doctor'],
                          'blood_type': data['blood_type'],
                          'userId': data['userId'],
                          'donor_name': data['donor_name'],
                        }).then((value) {
                          // Uklonite ili ažurirajte izvorni dokument u kolekciji "blood_donation"
                          bloodDonationRef
                              .doc(document.id)
                              .delete(); // Ili .update() za ažuriranje statusa

                          // Navigacija na stranicu DoseEntryPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DoseEntryPage()), // Pretpostavljajući da postoji DoseEntryPage widget
                          );
                        }).catchError((error) {
                          // Obrada grešaka ako dođe do problema s dodavanjem u kolekciju "accepted"
                          print(
                              'Error adding document to accepted collection: $error');
                        });
                      },
                      child: Text('Prihvati'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Stvaranje reference za dokument
                        DocumentReference bloodDonationDocRef =
                            FirebaseFirestore.instance
                                .collection('blood_donation')
                                .doc(document.id);
                        // Brisanje dokumenta iz baze podataka
                        bloodDonationDocRef.delete().then((value) {
                          print('Document successfully deleted');
                        }).catchError((error) {
                          print('Error deleting document: $error');
                        });
                      },
                      child: Text('Odbij'),
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
