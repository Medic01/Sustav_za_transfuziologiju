import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sustav_za_transfuziologiju/screens/user/welcome_page.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';
import '../enums/blood_types.dart';
import '../widgets/blood_type_dropdown_widget.dart';

class BloodDonationReservationPage extends StatefulWidget {
  const BloodDonationReservationPage({super.key});

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
  String? _userId;
  final _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  SessionManager sessionManager = SessionManager();

  @override
  void initState() {

    sessionManager.getUserId().then((value) {
      _userId = value;
    });
    super.initState();
    _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedBloodType != null) {
      await FirebaseFirestore.instance
          .collection('donation_date')
          .add({
        'donor_name': _nameController.text,
        'email': _emailController.text,
        'date': _dateController.text,
        'blood_type': _selectedBloodType,
        'user_id': _userId
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content:
              const Text('Your blood donation reservation has been submitted.'),
          actions: [
            TextButton(
              onPressed: () {

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('OK'),
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
        title: const Text('Blood Donation Reservation'),
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
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration:
                      const InputDecoration(labelText: 'Datum'),
                  inputFormatters: [_dateMaskFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite željeni datum: ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
