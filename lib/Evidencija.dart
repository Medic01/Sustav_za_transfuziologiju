import 'package:flutter/material.dart';
import 'Evidencija_dolazaka.dart';

class Evidencija extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evidencija'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Uspješno spremljeno',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            _buildGoToBloodDonationFormButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGoToBloodDonationFormButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BloodDonationForm()),
        );
      },
      child: Text('Idi na stranicu kontrola darivanja krvi'),
    );
  }
}
