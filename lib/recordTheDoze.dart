import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordTheDoze extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController quantityController = TextEditingController();

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
                    Text('user_id ${data['user_id']}'),
                    // New options
                    Text(
                      'Doza obrađena: ${data['doza_obradjena']}',
                      style: TextStyle(
                          color: data['doza_obradjena'] == true
                              ? Colors.green
                              : Colors.black),
                    ),
                    Text(
                      'Doza iskorištena: ${data['doza_iskoristena']}',
                      style: TextStyle(
                          color: data['doza_iskoristena'] == true
                              ? Colors.green
                              : Colors.black),
                    ),
                    Text(
                      'Količina donirane doze: ${data['kolicina_donirane_doze'] ?? 'N/A'}',
                      style: TextStyle(
                          color: data['kolicina_donirane_doze'] == 100
                              ? Colors.red
                              : Colors.green),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Dodavanje logike za označavanje doze kao obrađene
                        FirebaseFirestore.instance
                            .collection('accepted')
                            .doc(document.id)
                            .update({
                          'doza_obradjena': true,
                        }).then((value) {
                          print('Doza je obrađena');
                        }).catchError((error) {
                          print(
                              'Greška prilikom označavanja doze kao obrađene: $error');
                        });
                      },
                      child: Text('Označi kao obrađeno'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Dodavanje logike za označavanje doze kao iskorištene
                        FirebaseFirestore.instance
                            .collection('accepted')
                            .doc(document.id)
                            .update({
                          'doza_iskoristena': true,
                        }).then((value) {
                          print('Doza je iskorištena');
                        }).catchError((error) {
                          print(
                              'Greška prilikom označavanja doze kao iskorištene: $error');
                        });
                      },
                      child: Text('Označi kao iskorišteno'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Unesite količinu donirane doze'),
                              content: TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Količina',
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Odustani'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String quantity = quantityController.text;
                                    int existingQuantity =
                                        data['kolicina_donirane_doze'] ?? 0;
                                    if (quantity.isNotEmpty &&
                                        int.tryParse(quantity) != null &&
                                        int.parse(quantity) >=
                                            existingQuantity &&
                                        int.parse(quantity) <= 100) {
                                      FirebaseFirestore.instance
                                          .collection('accepted')
                                          .doc(document.id)
                                          .update({
                                        'kolicina_donirane_doze':
                                            int.parse(quantity),
                                      }).then((value) {
                                        print(
                                            'Količina donirane doze je unesena');
                                        Navigator.pop(context);
                                      }).catchError((error) {
                                        print(
                                            'Greška prilikom unosa količine donirane doze: $error');
                                      });
                                    } else if (int.parse(quantity) <
                                        existingQuantity) {
                                      print(
                                          'Ne možete unijeti manju količinu od postojeće');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Ne možete unijeti manju količinu od postojeće'),
                                      ));
                                    } else {
                                      print('Neispravan unos količine');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Količina mora biti između $existingQuantity i 100'),
                                      ));
                                    }
                                  },
                                  child: Text('Potvrdi'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Unesi količinu'),
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
