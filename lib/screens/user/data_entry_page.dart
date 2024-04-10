import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustav_za_transfuziologiju/models/user_data.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/gender.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/welcome_page.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';
import 'package:sustav_za_transfuziologiju/services/user_data_service.dart';
import '../enums/blood_types.dart';
import '../widgets/blood_type_dropdown_widget.dart';
import '../widgets/date_picker_widget.dart';

class DataEntryPage extends StatefulWidget {
  final String email;

  const DataEntryPage({Key? key, required this.email}) : super(key: key);

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _uniqueCitizensIdController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  UserDataService _userDataService = UserDataService();
  BloodTypes? _selectedBloodType;
  Gender? _selectedGender;
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  Future<void> saveDataToFirestore({
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

      Future<void> saveDataLocally({
        required String name,
        required String surname,
        required String email,
        required String uniqueCitizensId,
        required String dateOfBirth,
        required String address,
        required String city,
        required String phoneNumber,
        BloodTypes? bloodType,
        required String gender,
      }) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', name);
        await prefs.setString('surname', surname);
        await prefs.setString('email', email);
        await prefs.setString('uniqueCitizensId', uniqueCitizensId);
        await prefs.setString('dateOfBirth', dateOfBirth);
        await prefs.setString('address', address);
        await prefs.setString('city', city);
        await prefs.setString('phoneNumber', phoneNumber);
        await prefs.setString('gender', gender);
      }

      await saveDataLocally(
        name: name,
        surname: surname,
        email: email,
        uniqueCitizensId: uniqueCitizensId,
        dateOfBirth: dateOfBirth,
        address: address,
        city: city,
        phoneNumber: phoneNumber,
        bloodType: bloodType,
        gender: gender,
      );

      UserData userData = UserData(
        name: name,
        surname: surname,
        email: email,
        uniqueCitizensId: uniqueCitizensId,
        dateOfBirth: dateOfBirth,
        address: address,
        city: city,
        phoneNumber: phoneNumber,
        bloodType: bloodType,
        gender: gender,
        isFirstLogin: false,
      );

      final userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      print("User Snapshot: $userSnapshot");

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        sessionManager.setUserId(userId);
        print("UserID: $userId");

        _userDataService.updateUser(userData);
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
            _buildTextField(
                labelText: 'Surname', controller: _surnameController),
            _buildTextField(
                labelText: 'Email',
                controller: _emailController,
                readOnly: true),
            _buildTextField(
                labelText: 'Unique Citizens ID',
                controller: _uniqueCitizensIdController),
            DatePickerWidget(controller: _dateOfBirthController),
            _buildGenderDropdownField(
              labelText: 'Gender',
              value: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            _buildTextField(
                labelText: 'Address', controller: _addressController),
            _buildTextField(labelText: 'City', controller: _cityController),
            _buildTextField(
                labelText: 'Phone Number', controller: _phoneNumberController),
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
    required Gender? value,
    required ValueChanged<Gender?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: DropdownButtonFormField<Gender>(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        value: value,
        onChanged: onChanged,
        items: Gender.values.map((gender) {
          return DropdownMenuItem<Gender>(
            value: gender,
            child: Text(gender.toString().split('.').last),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_selectedBloodType == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Trebate odabrati krvnu grupu!"),
              ),
            );
            return;
          }

          if (_selectedGender == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Odaberite spol!"),
              ),
            );
          }

          await saveDataLocally(
            name: _nameController.text,
            email: _emailController.text,
          );

          Map<String, String> _loggedInUserData = {
            'name': _nameController.text,
            'email': _emailController.text,
          };

          saveDataToFirestore(
            name: _nameController.text,
            surname: _surnameController.text,
            email: _emailController.text,
            uniqueCitizensId: _uniqueCitizensIdController.text,
            dateOfBirth: _dateOfBirthController.text,
            address: _addressController.text,
            city: _cityController.text,
            phoneNumber: _phoneNumberController.text,
            bloodType: _selectedBloodType,
            gender: _selectedGender!.toString().split('.').last,
            context: context,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomePage(userData: _loggedInUserData),
            ),
          );
        },
        child: const Text('Save'),
      ),
    );
  }

  saveDataLocally({required String name, required String email}) {}
}
