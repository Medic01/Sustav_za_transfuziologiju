import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importamo paket flutter/services
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'blood_donation_records.dart';

class BloodDonationForm extends StatelessWidget {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _technicianNameController =
      TextEditingController();
  final TextEditingController _hemoglobinController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();
  final TextEditingController _bloodTypeController =
      TextEditingController(); // Dodajemo kontroler za krvnu grupu

  // Mask formatter for the date field
  final MaskTextInputFormatter _dateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void saveDataToFirestore({
    required String date,
    required String place,
    required String doctorName,
    required String technicianName,
    required String hemoglobin,
    required String bloodPressure,
    required bool donationRejected,
    required String rejectionReason,
    required String bloodType, // Dodajemo bloodType kao argument
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('blood_donation').add({
        'blood_donation_location': place,
        'date_od_donation': date,
        'donor_blood_pressure': bloodPressure,
        'hemoglobin': hemoglobin,
        'name_of_doctor': doctorName,
        'technicianName': technicianName,
        'blood_type': bloodType, // Dodajemo krvnu grupu u dokument
      });

      print('Data successfully saved to Firestore.');
    } catch (error) {
      print('Error saving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation Control'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Fill in the blood donation control details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            _buildTextField(
              labelText: 'Date',
              controller: _dateController,
              inputFormatter: [_dateMaskFormatter],
            ),
            _buildTextField(
              labelText: 'Place',
              controller: _placeController,
            ),
            _buildTextField(
              labelText: 'Doctor Name',
              controller: _doctorNameController,
            ),
            _buildTextField(
              labelText: 'Technician Name',
              controller: _technicianNameController,
            ),
            _buildTextField(
              labelText: 'Hemoglobin (g/dL)',
              controller: _hemoglobinController,
            ),
            _buildTextField(
              labelText: 'Blood Pressure',
              controller: _bloodPressureController,
            ),
            _buildTextField(
              labelText: 'Blood Type', // Dodajemo labelu za krvnu grupu
              controller:
                  _bloodTypeController, // Dodajemo kontroler za krvnu grupu
            ),
            Row(
              children: [
                Text('Donation Rejected: '),
                Checkbox(
                  value: false,
                  onChanged: null,
                ),
              ],
            ),
            _buildTextField(
              labelText: 'Rejection Reason',
              controller: _rejectionReasonController,
            ),
            SizedBox(height: 20.0),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatter, // Set input formatter here
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
            date: _dateController.text,
            place: _placeController.text,
            doctorName: _doctorNameController.text,
            technicianName: _technicianNameController.text,
            hemoglobin: _hemoglobinController.text,
            bloodPressure: _bloodPressureController.text,
            donationRejected: false,
            rejectionReason: _rejectionReasonController.text,
            bloodType:
                _bloodTypeController.text, // Prosleđujemo unetu krvnu grupu
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BloodDonationRecords()),
          );
        },
        child: Text('Save'),
      ),
    );
  }
}
