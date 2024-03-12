import 'package:flutter/material.dart';

class PocetnaPage extends StatelessWidget {
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
            _buildTextField(labelText: 'Ime'),
            _buildTextField(labelText: 'Prezime'),
            _buildTextField(labelText: 'E-mail'),
            _buildTextField(labelText: 'JMBG'),
            _buildTextField(labelText: 'Datum rođenja'),
            _buildTextField(labelText: 'Adresa'),
            _buildTextField(labelText: 'Grad'),
            _buildTextField(labelText: 'Broj telefona'),
            _buildTextField(labelText: 'Krvna grupa'),
            SizedBox(height: 20.0),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String labelText}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextField(
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
          // Dodajte ovdje logiku za spremanje podataka
        },
        child: Text('Spremi'),
      ),
    );
  }
}
