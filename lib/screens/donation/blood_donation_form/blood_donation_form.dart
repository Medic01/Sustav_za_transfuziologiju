import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/blood_types.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/blood_type_dropdown_widget/blood_type_dropdown_widget.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/date_picker/date_picker_widget.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/error_dialog/error_dialog.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/success_dialog/success_dialog.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'blood_donation_form_styles.dart';

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
  final TextEditingController _millilitersController = TextEditingController();
  final DonationService _donationService = DonationService();
  final Logger logger = Logger("BloodDonationForm");
  BloodTypes? _selectedBloodType;
  late String _userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.donationForm,
            style: headerTextColor,
        ),
        backgroundColor: titleBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.donorTxt,
              style: textStyle,
            ),
            const SizedBox(height: sizedBoxHeight),
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
            _buildTextField(
              labelText: AppLocalizations.of(context)!.donatedAmount,
              controller: _millilitersController,
            ),
            BloodTypeDropdownWidget(
              onChanged: (BloodTypes? newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
              value: _selectedBloodType,
            ),
            const SizedBox(height: sizedBoxHeight),
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
      margin: textFieldMargin,
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          labelText: labelText,
          border: inputDecorationBorder,
        ),
      ),
    );
  }

  bool _validateHemoglobin(String hemoglobinText) {
    if (hemoglobinText.isEmpty) {
      ErrorDialog.show(context);
      return false;
    }
    try {
      int.parse(hemoglobinText);
    } catch (e) {
      ErrorDialog.show(context);
      return false;
    }
    return true;
  }

  bool _validateMilliliters(String millilitersText) {
    if (millilitersText.isEmpty) {
      ErrorDialog.show(context);
      return false;
    }
    try {
      int.parse(millilitersText);
    } catch (e) {
      ErrorDialog.show(context);
      return false;
    }
    return true;
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (!_validateHemoglobin(_hemoglobinController.text) || !_validateMilliliters(_millilitersController.text)) {
            return;
          }

          try {
            await _donationService.updateReservationAndAccept(
              documentId: widget.documentId,
              location: _placeController.text,
              hemoglobin: _hemoglobinController.text,
              bloodPressure: _bloodPressureController.text,
              doctorName: _doctorNameController.text,
              technicianName: _technicianNameController.text,
              donatedDose: int.tryParse(_millilitersController.text) ?? 0,
            );
            Navigator.pop(context);
            SuccessDialog.show(context);
          } catch (error) {
            logger.severe("Error while trying to update and accept donations!");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.genericErrMsg)),
            );
          }
        },
        style: buttonStyle,
        child: Text(
          AppLocalizations.of(context)!.saveBtn,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}