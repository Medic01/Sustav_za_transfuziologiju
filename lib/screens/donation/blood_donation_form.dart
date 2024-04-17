import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/blood_types.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import '../widgets/date_picker_widget.dart';
import '../widgets/blood_type_dropdown_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodDonationForm extends StatefulWidget {
  final String date;
  final String donorName;
  final String bloodType;
  final String userId;
  final String documentId;

  const BloodDonationForm({
    Key? key,
    required this.date,
    required this.donorName,
    required this.bloodType,
    required this.userId,
    required this.documentId,
  }) : super(key: key);

  @override
  _BloodDonationFormState createState() => _BloodDonationFormState();
}

class _BloodDonationFormState extends State<BloodDonationForm> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _donorNameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _technicianNameController = TextEditingController();
  final TextEditingController _hemoglobinController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final DonationService _donationService = DonationService();
  final Logger logger = Logger("BloodDonationForm");
  BloodTypes? _selectedBloodType;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.donationForm),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.donorTxt,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            DatePickerWidget(controller: _dateController),
            _buildTextField(
              labelText: AppLocalizations.of(context)!.donorName,
              controller: _donorNameController,
            ),
            _buildTextField(
              labelText: AppLocalizations.of(context)!.donationLocation,
              controller: _placeController,
            ),
            _buildTextField(
              labelText: AppLocalizations.of(context)!.doctorName,
              controller: _doctorNameController,
            ),
            _buildTextField(
              labelText: AppLocalizations.of(context)!.technicianName,
              controller: _technicianNameController,
            ),
            _buildTextField(
              labelText: AppLocalizations.of(context)!.hemoglobin,
              controller: _hemoglobinController,
            ),
            _buildTextField(
              labelText: AppLocalizations.of(context)!.bloodPressure,
              controller: _bloodPressureController,
            ),
            BloodTypeDropdownWidget(
              onChanged: (BloodTypes? newValue) {
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
        onPressed: () async {
          try {
            await _donationService.updateReservationAndAccept(
              documentId: widget.documentId,
              location: _placeController.text,
              hemoglobin: _hemoglobinController.text,
              bloodPressure: _bloodPressureController.text,
              doctorName: _doctorNameController.text,
              technicianName: _technicianNameController.text,
            );
            Navigator.pop(context);
          } catch (error) {
            logger.severe("Error while trying to update and accept donations!");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.genericErrMsg)),
            );
          }
        },
        child: Text(AppLocalizations.of(context)!.saveBtn),
      ),
    );
  }
}