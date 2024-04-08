import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/models/donation.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/blood_types.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import '../widgets/date_picker_widget.dart';
import '../widgets/blood_type_dropdown_widget.dart';
import 'blood_donation_records.dart';

class BloodDonationForm extends StatefulWidget {
  final String date;
  final String donorName;
  final String bloodType;
  final String userId;

  const BloodDonationForm({
    Key? key,
    required this.date,
    required this.donorName,
    required this.bloodType,
    required this.userId,
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
  final TextEditingController _rejectionReasonController = TextEditingController();
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

  void saveDataToFirestore(Donation data) async {
    try {
      await _donationService.saveDonationData(data);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BloodDonationRecords()),
      );
    } catch (error) {
      logger.severe('Error saving data: $error');
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
              controller: _placeController,
            ),
            _buildTextField(
              labelText: 'Doctors Name',
              controller: _doctorNameController,
            ),
            _buildTextField(
              labelText: 'Technicians Name',
              controller: _technicianNameController,
            ),
            _buildTextField(
              labelText: 'Hemoglobin (g/dL)',
              controller: _hemoglobinController,
            ),
            _buildTextField(
              labelText: 'Blood Pressure',
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
        onPressed: () {
          Donation data = Donation(
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
            userId: _userId,
          );
          saveDataToFirestore(data);
        },
        child: const Text('Save'),
      ),
    );
  }
}
