import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import '../enums/blood_types.dart';
import '../widgets/blood_type_dropdown_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final DonationService _donationService = DonationService();
  String? _selectedBloodType;
  late MaskTextInputFormatter _dateMaskFormatter;
  String? _userId;
  final _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    sessionManager.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
      _loadUserData();
    });
    _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  void _loadUserData() async {
    if (_userId != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      setState(() {
        final name = userData['name'];
        final surname = userData['surname'];
        _nameController.text = '$name $surname';
        _emailController.text = userData['email'];
        _selectedBloodType = userData['blood_type'];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedBloodType != null) {
      await _donationService.saveBloodDonationData(
        donorName: _nameController.text,
        email: _emailController.text,
        date: _dateController.text,
        bloodType: _selectedBloodType!,
        userId: _userId!,
      );

      _nameController.clear();
      _emailController.clear();
      _dateController.clear();
      setState(() {
        _selectedBloodType = null;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.success),
          content:
          Text(AppLocalizations.of(context)!.reservationSuccessText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
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
        title: Text(AppLocalizations.of(context)!.donationDateReservation),
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
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.fullNameLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.fullNameTxt;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.emailTxt),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.emailReminder;
                    }
                    if (!_emailRegExp.hasMatch(value)) {
                      return AppLocalizations.of(context)!.emailErrorMessage;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.date),
                  inputFormatters: [_dateMaskFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterDonationDate;
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
                  child: Text(AppLocalizations.of(context)!.submitBtn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}