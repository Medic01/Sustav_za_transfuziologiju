import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'evidence.dart';
import 'dataEntry.dart';

class StartPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jmbgController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  void saveDataToFirestore({
    required String name,
    required String surname,
    required String email,
    required String jmbg,
    required String dateOfBirth,
    required String address,
    required String city,
    required String phoneNumber,
    required String bloodType,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('korisnici').add({
        'name': name,
        'surname': surname,
        'email': email,
        'jmbg': jmbg,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'city': city,
        'phoneNumber': phoneNumber,
        'bloodType': bloodType,
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
        title: Text('Home Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Fill in your details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            _buildTextField(labelText: 'Name', controller: _nameController),
            _buildTextField(
                labelText: 'Surname', controller: _surnameController),
            _buildTextField(labelText: 'Email', controller: _emailController),
            _buildTextField(labelText: 'JMBG', controller: _jmbgController),
            _buildTextField(
                labelText: 'Date of Birth', controller: _dateOfBirthController),
            _buildTextField(
                labelText: 'Address', controller: _addressController),
            _buildTextField(labelText: 'City', controller: _cityController),
            _buildTextField(
                labelText: 'Phone Number', controller: _phoneNumberController),
            _buildTextField(
                labelText: 'Blood Type', controller: _bloodTypeController),
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
            name: _nameController.text,
            surname: _surnameController.text,
            email: _emailController.text,
            jmbg: _jmbgController.text,
            dateOfBirth: _dateOfBirthController.text,
            address: _addressController.text,
            city: _cityController.text,
            phoneNumber: _phoneNumberController.text,
            bloodType: _bloodTypeController.text,
          );

          // After saving the data, navigate to the Evidence page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Evidence()),
          );
        },
        child: Text('Save'),
      ),
    );
  }
}
