import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoseEntryPage extends StatefulWidget {
  const DoseEntryPage({super.key});

  @override
  _DoseEntryPageState createState() => _DoseEntryPageState();
}

class _DoseEntryPageState extends State<DoseEntryPage> {
  String? selectedBloodType;

  @override
  Widget build(BuildContext context) {
    TextEditingController quantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted blood donations'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Choose blood type',
              border: OutlineInputBorder(),
            ),
            value: selectedBloodType,
            onChanged: (String? newValue) {
              setState(() {
                selectedBloodType = newValue;
              });
            },
            items: <String>[
              'All',
              'A_POSITIVE',
              'A_NEGATIVE',
              'B_POSITIVE',
              'B_NEGATIVE',
              'AB_POSITIVE',
              'AB_NEGATIVE',
              'O_POSITIVE',
              'O_NEGATIVE'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: selectedBloodType == 'All'
                  ? FirebaseFirestore.instance
                      .collection('accepted')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('accepted')
                      .where('blood_type', isEqualTo: selectedBloodType)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('An error occurred: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          title: Text('Lokacija donacije: ${data['location']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Datum donacije: ${data['date']}'),
                              Text('Krvni tlak davatelja: ${data['blood_pressure']}'),
                              Text('Hemoglobin: ${data['hemoglobin']}'),
                              Text('Ime doktora: ${data['doctor_name']}'),
                              Text('Krvna grupa: ${data['blood_type']}'),
                              Text('Ime davatelja: ${data['donor_name']}'),
                              Text('Krv obrađena: ${data['dose_processed']}',
                                style: TextStyle(
                                    color: data['dose_processed'] == true
                                        ? Colors.green
                                        : Colors.black),
                              ),
                              Text('Krv iskorištena: ${data['dose_used']}',
                                style: TextStyle(
                                    color: data['dose_used'] == true
                                        ? Colors.green
                                        : Colors.black),
                              ),
                              Text('Količina donirana: ${data['donated_dose'] ?? 'N/A'}',
                                style: TextStyle(
                                    color: data['donated_dose'] == 100
                                        ? Colors.red
                                        : Colors.green),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('accepted')
                                    .doc(document.id)
                                    .update({
                                  'dose_processed': true,
                                }).then((value) {
                                  print('Doza je obrađena');
                                }).catchError((error) {
                                  print('Greška prilikom označavanja doze kao obrađene: $error');
                                });
                              },
                              child: const Text('Obrađena'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('accepted')
                                    .doc(document.id)
                                    .update({
                                  'dose_used': true,
                                }).then((value) {
                                  print('Doza je iskorištena');
                                }).catchError((error) {
                                  print('Greška prilikom označavanja doze kao iskorištene: $error');
                                });
                              },
                              child: const Text('Iskorišteno'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Unesite količinu donirane doze'),
                                      content: TextField(
                                        controller: quantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Količina',
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Odustani'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            String quantity =
                                                quantityController.text;
                                            int existingQuantity = data['donated_dose'] ??
                                                0;
                                            if (quantity.isNotEmpty &&
                                                int.tryParse(quantity) != null
                                                && int.parse(quantity) >= existingQuantity
                                                && int.parse(quantity) <= 100) {
                                              FirebaseFirestore.instance
                                                  .collection('accepted')
                                                  .doc(document.id)
                                                  .update({
                                                'donated_dose':
                                                    int.parse(quantity),
                                              }).then((value) {
                                                print('Količina donirane doze je unesena');
                                                Navigator.pop(context);
                                              }).catchError((error) {
                                                print('Greška prilikom unosa količine donirane doze: $error');
                                              });
                                            } else if (int.parse(quantity) < existingQuantity) {
                                              print('Ne možete unijeti manju količinu od postojeće');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text('Ne možete unijeti manju količinu od postojeće'),
                                              ));
                                            } else {
                                              print('Neispravan unos količine');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text('Količina mora biti između $existingQuantity i 100'),
                                              ));
                                            }
                                          },
                                          child: const Text('Potvrdi'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('Količina'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
