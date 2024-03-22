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
                      child: Text('Accept'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String declineReason =
                                ''; // Varijabla za pohranu razloga odbijanja

                            return AlertDialog(
                              title: Text('Enter Decline Reason'),
                              content: TextField(
                                onChanged: (value) {
                                  declineReason =
                                      value; // Ažuriranje razloga odbijanja kad korisnik unese nešto
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter reason here...',
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    // Spremi odbijenu donaciju u Firebase zajedno s razlogom
                                    FirebaseFirestore.instance
                                        .collection('declined_donations')
                                        .add({
                                      'blood_donation_location':
                                          data['blood_donation_location'],
                                      'date_od_donation':
                                          data['date_od_donation'],
                                      'donor_blood_pressure':
                                          data['donor_blood_pressure'],
                                      'hemoglobin': data['hemoglobin'],
                                      'name_of_doctor': data['name_of_doctor'],
                                      'blood_type': data['blood_type'],
                                      'userId': data['userId'],
                                      'donor_name': data['donor_name'],
                                      'reason_for_decline':
                                          declineReason, // Dodavanje razloga odbijanja
                                    }).then((value) {
                                      print(
                                          'Odbijena donacija dodana u kolekciju declined_donations');
                                      // Uklonite dokument iz kolekcije "blood_donation"
                                      FirebaseFirestore.instance
                                          .collection('blood_donation')
                                          .doc(document.id)
                                          .delete()
                                          .then((_) {
                                        print('Dokument uspješno obrisan');
                                      }).catchError((error) {
                                        print(
                                            'Greška pri brisanju dokumenta: $error');
                                      });

                                      Navigator.of(context)
                                          .pop(); // Zatvaranje dijaloga nakon što korisnik pritisne gumb
                                    }).catchError((error) {
                                      print(
                                          'Greška pri dodavanju odbijene donacije: $error');
                                    });
                                  },
                                  child: Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Decline'),
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
