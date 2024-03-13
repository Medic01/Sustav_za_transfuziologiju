import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'evidencija.dart';
import 'prva.dart';

class BloodDonationForm extends StatelessWidget {
  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _mjestoController = TextEditingController();
  final TextEditingController _imeLijecnikaController = TextEditingController();
  final TextEditingController _imeTehnicaraController = TextEditingController();
  final TextEditingController _hemoglobinController = TextEditingController();
  final TextEditingController _krvniTlakController = TextEditingController();
  final TextEditingController _razlogOdbijanjaController =
      TextEditingController();

  void saveDataToFirestore({
    required String datum,
    required String mjesto,
    required String imeLijecnika,
    required String imeTehnicara,
    required String hemoglobin,
    required String krvniTlak,
    required bool odbijenoDarivanje,
    required String razlogOdbijanja,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('evidencija_dolazaka').add({
        'datum': datum,
        'mjesto': mjesto,
        'imeLijecnika': imeLijecnika,
        'imeTehnicara': imeTehnicara,
        'hemoglobin': hemoglobin,
        'krvniTlak': krvniTlak,
        'odbijenoDarivanje': odbijenoDarivanje,
        'razlogOdbijanja': razlogOdbijanja,
      });

      print('Podaci su uspješno spremljeni u Firestore.');
    } catch (error) {
      print('Greška pri spremanju podataka: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontrola darivanja krvi'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Popunite podatke o kontroli darivanja krvi:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            _buildTextField(labelText: 'Datum', controller: _datumController),
            _buildTextField(labelText: 'Mjesto', controller: _mjestoController),
            _buildTextField(
                labelText: 'Ime i prezime liječnika',
                controller: _imeLijecnikaController),
            _buildTextField(
                labelText: 'Ime i prezime tehničara',
                controller: _imeTehnicaraController),
            _buildTextField(
                labelText: 'Hemoglobin (g/dL)',
                controller: _hemoglobinController),
            _buildTextField(
                labelText: 'Krvni tlak darovatelja',
                controller: _krvniTlakController),
            Row(
              children: [
                Text('Odbijeno darivanje: '),
                Checkbox(
                  value: false,
                  onChanged: null,
                ),
              ],
            ),
            _buildTextField(
                labelText: 'Razlog odbijanja',
                controller: _razlogOdbijanjaController),
            SizedBox(height: 20.0),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String labelText, required TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          saveDataToFirestore(
            datum: _datumController.text,
            mjesto: _mjestoController.text,
            imeLijecnika: _imeLijecnikaController.text,
            imeTehnicara: _imeTehnicaraController.text,
            hemoglobin: _hemoglobinController.text,
            krvniTlak: _krvniTlakController.text,
            odbijenoDarivanje:
                false, // Promijenite na true ako je darivanje odbijeno
            razlogOdbijanja: _razlogOdbijanjaController.text,
          );

          // Nakon spremanja podataka, možete dodati navigaciju na drugu stranicu ovdje
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WelcomePage()),
          );
        },
        child: Text('Spremi'),
      ),
    );
  }
}
