import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Evidencija.dart';

class PocetnaPage extends StatelessWidget {
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _prezimeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jmbgController = TextEditingController();
  final TextEditingController _datumRodjenjaController =
      TextEditingController();
  final TextEditingController _adresaController = TextEditingController();
  final TextEditingController _gradController = TextEditingController();
  final TextEditingController _brojTelefonaController = TextEditingController();
  final TextEditingController _krvnaGrupaController = TextEditingController();

  void saveDataToFirestore({
    required String ime,
    required String prezime,
    required String email,
    required String jmbg,
    required String datumRodjenja,
    required String adresa,
    required String grad,
    required String brojTelefona,
    required String krvnaGrupa,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('korisnici').add({
        'ime': ime,
        'prezime': prezime,
        'email': email,
        'jmbg': jmbg,
        'datumRodjenja': datumRodjenja,
        'adresa': adresa,
        'grad': grad,
        'brojTelefona': brojTelefona,
        'krvnaGrupa': krvnaGrupa,
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
        title: Text('Početna stranica'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Popunite vaše podatke:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            _buildTextField(labelText: 'Ime', controller: _imeController),
            _buildTextField(
                labelText: 'Prezime', controller: _prezimeController),
            _buildTextField(labelText: 'E-mail', controller: _emailController),
            _buildTextField(labelText: 'JMBG', controller: _jmbgController),
            _buildTextField(
                labelText: 'Datum rođenja',
                controller: _datumRodjenjaController),
            _buildTextField(labelText: 'Adresa', controller: _adresaController),
            _buildTextField(labelText: 'Grad', controller: _gradController),
            _buildTextField(
                labelText: 'Broj telefona',
                controller: _brojTelefonaController),
            _buildTextField(
                labelText: 'Krvna grupa', controller: _krvnaGrupaController),
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
            ime: _imeController.text,
            prezime: _prezimeController.text,
            email: _emailController.text,
            jmbg: _jmbgController.text,
            datumRodjenja: _datumRodjenjaController.text,
            adresa: _adresaController.text,
            grad: _gradController.text,
            brojTelefona: _brojTelefonaController.text,
            krvnaGrupa: _krvnaGrupaController.text,
          );

          // Nakon spremanja podataka, navigirajte na Evidencija stranicu
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Evidencija()),
          );
        },
        child: Text('Spremi'),
      ),
    );
  }
}
