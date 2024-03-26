import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/screens/user/welcome_page.dart';
import '../enums/blood_types.dart';
import '../widgets/blood_type_dropdown_widget.dart';
import '../widgets/date_picker_widget.dart';

class DataEntryPage extends StatefulWidget {
  final String email;

  const DataEntryPage({super.key, required this.email});

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _uniqueCitizensIdController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  BloodTypes? _selectedBloodType;
  String _selectedGender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  void saveDataToFirestore({
    required String name,
    required String surname,
    required String email,
    required String uniqueCitizensId,
    required String dateOfBirth,
    required String address,
    required String city,
    required String phoneNumber,
    required BloodTypes? bloodType,
    required String gender,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      print("User Snapshot: $userSnapshot");

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        print("UserID: $userId");

        await firestore.collection('users').doc(userId).update({
          'name': name,
          'surname': surname,
          'email': email,
          'unique_citizens_id': uniqueCitizensId,
          'date_of_birth': dateOfBirth,
          'address': address,
          'city': city,
          'phone_number': phoneNumber,
          'blood_type': bloodType?.toString().split('.').last,
          'gender': gender,
          'is_first_login': false,
        });
      }

      print('Data successfully saved to Firestore.');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Successfully saved"),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    } catch (error) {
      print('Error saving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Fill in your details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            _buildTextField(labelText: 'Name', controller: _nameController),
            _buildTextField(labelText: 'Surname', controller: _surnameController),
            _buildTextField(labelText: 'Email', controller: _emailController, readOnly: true),
            _buildTextField(labelText: 'Unique Citizens ID', controller: _uniqueCitizensIdController),
            DatePickerWidget(controller: _dateOfBirthController),
            _buildGenderDropdownField(labelText: 'Gender', value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                items: _genderOptions
                    .map<DropdownMenuItem<String>>((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList()),
            _buildTextField(labelText: 'Address', controller: _addressController),
            _buildTextField(labelText: 'City', controller: _cityController),
            _buildTextField(labelText: 'Phone Number', controller: _phoneNumberController),
            BloodTypeDropdownWidget(
              onChanged: (newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
              value: _selectedBloodType,
            ),
            const SizedBox(height: 20.0),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String labelText,
      required TextEditingController controller,
      bool readOnly = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGenderDropdownField({
    required String labelText,
    required String value,
    required ValueChanged<String?> onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        value: value,
        onChanged: onChanged,
        items: items,
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
            gender: _selectedGender,
            dateOfBirth: _dateOfBirthController.text,
            address: _addressController.text,
            city: _cityController.text,
            phoneNumber: _phoneNumberController.text,
            bloodType: _selectedBloodType,
            context: context,
          );
        },
        child: const Text('Save'),
      ),
    );
  }
}
