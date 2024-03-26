import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/date_picker_widget.dart';
import '../enums/blood_types.dart';
import '../widgets/blood_type_dropdown_widget.dart';
import 'blood_donation_records.dart';

class BloodDonationForm extends StatefulWidget {
  final String date;
  final String donorName;
  final String bloodType;
  final String userId;

  const BloodDonationForm({super.key, 
    required this.date,
    required this.donorName,
    required this.bloodType,
    required this.userId
  });

  @override
  _BloodDonationFormState createState() => _BloodDonationFormState();
}

class _BloodDonationFormState extends State<BloodDonationForm> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _donorNameController = TextEditingController();
  BloodTypes? _selectedBloodType;
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _technicianNameController =
      TextEditingController();
  final TextEditingController _hemoglobinController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _dateController.text = widget.date;
    _donorNameController.text = widget.donorName;
    _selectedBloodType = BloodTypes.values.firstWhere(
      (element) => element.toString().split('.').last == widget.bloodType,
    );
  }

  void saveDataToFirestore({
    required String date,
    required String place,
    required String doctorName,
    required String technicianName,
    required String hemoglobin,
    required String bloodPressure,
    required bool donationRejected,
    required String rejectionReason,
    required BloodTypes? bloodType,
    required String donorName,
    required String userId,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('blood_donation').add({
        'location': place,
        'date': date,
        'blood_pressure': bloodPressure,
        'hemoglobin': hemoglobin,
        'doctor_name': doctorName,
        'technician_name': technicianName,
        'blood_type': bloodType.toString().split('.').last,
        'donor_name': donorName,
        'user_id': userId,
      });

      print('Data successfully saved to Firestore.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BloodDonationRecords()),
      );
    } catch (error) {
      print('Error saving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donation Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Fill in the blood donation control details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            DatePickerWidget(controller: _dateController),
            _buildTextField(
              labelText: 'Donor Name',
              controller: _donorNameController,
            ),
            _buildTextField(
              labelText: 'Place',
              controller: _placeController, // Add your controller here
            ),
            _buildTextField(
              labelText: 'Doctors Name',
              controller: _doctorNameController, // Add your controller here
            ),
            _buildTextField(
              labelText: 'Technicians Name',
              controller: _technicianNameController, // Add your controller here
            ),
            _buildTextField(
              labelText: 'Hemoglobin (g/dL)',
              controller: _hemoglobinController, // Add your controller here
            ),
            _buildTextField(
              labelText: 'Blood Pressure',
              controller: _bloodPressureController, // Add your controller here
            ),
            BloodTypeDropdownWidget(
              onChanged: (BloodTypes? newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
              value: _selectedBloodType, // Set the initial value
            ),
            const SizedBox(height: 20.0),
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
      margin: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
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
            bloodType: _selectedBloodType,
            donorName: _donorNameController.text,
            userId: _userId
          );
        },
        child: const Text('Save'),
      ),
    );
  }
}
