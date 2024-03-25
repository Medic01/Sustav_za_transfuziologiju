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
        title: const Text('Accepted bloods'),
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
                          title: Text(
                              'blood_donation_location: ${data['blood_donation_location']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'date_od_donation: ${data['date_od_donation']}'),
                              Text(
                                  'donor_blood_pressure ${data['donor_blood_pressure']}'),
                              Text('hemoglobin ${data['hemoglobin']}'),
                              Text('name_of_doctor ${data['name_of_doctor']}'),
                              Text('blood_type ${data['blood_type']}'),
                              Text('donor_name ${data['donor_name']}'),
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
                                  'doza_obradjena': true,
                                }).then((value) {
                                  print('Doza je obrađena');
                                }).catchError((error) {
                                  print(
                                      'Greška prilikom označavanja doze kao obrađene: $error');
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
                                  'doza_iskoristena': true,
                                }).then((value) {
                                  print('Doza je iskorištena');
                                }).catchError((error) {
                                  print(
                                      'Greška prilikom označavanja doze kao iskorištene: $error');
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
                                      title: const Text(
                                          'Unesite količinu donirane doze'),
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
                                            int existingQuantity = data[
                                                    'kolicina_donirane_doze'] ??
                                                0;
                                            if (quantity.isNotEmpty &&
                                                int.tryParse(quantity) !=
                                                    null &&
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
                                                  .showSnackBar(const SnackBar(
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
