import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/user_page.dart';

class DataEntryPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController;
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _uniqueCitizensIdController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  
  DataEntryPage({required String userEmail}) : _emailController = TextEditingController(text: userEmail);

  void saveDataToFirestore({
    required String name,
    required String surname,
    required String email,
    required String uniqueCitizensId,
    required String dateOfBirth,
    required String address,
    required String city,
    required String phoneNumber,
    required String bloodType,
    required String gender,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      final userSnapshot = await firestore.collection('users').where('email', isEqualTo: email).get();
      print("User Snapshot: $userSnapshot");

      final userId = userSnapshot.docs.first.id;
      print("UserID: $userId");

      await firestore.collection('users').doc(userId).update({
        'name': name,
        'surname': surname,
        'email': email,
        'unique_citizens_id': uniqueCitizensId,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'city': city,
        'phoneNumber': phoneNumber,
        'bloodType': bloodType,
        'gender' : gender,
        'isFirstLogin': false,
      });

      print('Data successfully saved to Firestore.');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Successfully saved"),
          );
        },
      );

      await Future.delayed(Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
      
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
            _buildTextField(labelText: 'Surname', controller: _surnameController),
            _buildTextField(labelText: 'Email', controller: _emailController, readOnly: true),
            _buildTextField(labelText: 'Unique Citizens ID', controller: _uniqueCitizensIdController),
            _buildTextField(labelText: 'Date of Birth', controller: _dateOfBirthController),
            _buildTextField(labelText: 'Gender', controller: _genderController),
            _buildTextField(labelText: 'Address', controller: _addressController),
            _buildTextField(labelText: 'City', controller: _cityController),
            _buildTextField(labelText: 'Phone Number', controller: _phoneNumberController),
            _buildTextField(labelText: 'Blood Type', controller: _bloodTypeController),
            SizedBox(height: 20.0),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String labelText, required TextEditingController controller, bool readOnly = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
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
            uniqueCitizensId: _uniqueCitizensIdController.text,
            gender: _genderController.text,
            dateOfBirth: _dateOfBirthController.text,
            address: _addressController.text,
            city: _cityController.text,
            phoneNumber: _phoneNumberController.text,
            bloodType: _bloodTypeController.text,
            context: context,
          );
        },
        child: Text('Save'),
      ),
    );
  }
}
