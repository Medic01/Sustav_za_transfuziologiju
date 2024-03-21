import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sustav_za_transfuziologiju/welcome_page.dart';
import '../enums/blood_types.dart';
import '../widgets/blood_type_dropdown_widget.dart';

class BloodDonationReservationPage extends StatefulWidget {
  @override
  _BloodDonationReservationPageState createState() =>
      _BloodDonationReservationPageState();
}

class _BloodDonationReservationPageState
    extends State<BloodDonationReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedBloodType;
  late MaskTextInputFormatter _dateMaskFormatter;
  final _emailRegExp =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // RegExp za provjeru e-pošte

  @override
  void initState() {
    super.initState();
    _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedBloodType != null) {
      // Save data to Firestore
      await FirebaseFirestore.instance
          .collection('date_reservation_blood_donation')
          .add({
        'name': _nameController.text,
        'email': _emailController.text,
        'date': _dateController.text,
        'blood_type': _selectedBloodType, // Sprema se kao string
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Your blood donation reservation has been submitted.'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigirajte na WelcomePage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation Reservation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!_emailRegExp.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Preferred Date'),
                  inputFormatters: [_dateMaskFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your preferred date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                BloodTypeDropdownWidget(
                  onChanged: (value) {
                    setState(() {
                      _selectedBloodType = value.toString().split('.').last;
                    });
                  },
                  value: _selectedBloodType != null
                      ? BloodTypes.values.firstWhere((element) =>
                          element.toString().split('.').last ==
                          _selectedBloodType)
                      : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
