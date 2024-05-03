import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'donation_list_card_style.dart';

class DonationListCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;
  final DonationService donationService;
  final TextEditingController quantityController;
  final Logger logger = Logger('DonationListCard');
  final VoidCallback? onProcessed;
  final VoidCallback? onUsed;

  DonationListCard({
    required this.data,
    required this.documentId,
    required this.donationService,
    required this.quantityController,
    this.onProcessed,
    this.onUsed,
  });

  @override
  Widget build(BuildContext context) {
    bool isProcessed = data['dose_processed'] == true;
    bool isUsed = data['dose_used'] == true;

    String bloodTypeDisplayName = mapBloodType(data['blood_type']);

    return Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        ListTile(
          title: Text('${AppLocalizations.of(context)!.donationLocation} ${data['location']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppLocalizations.of(context)!.donationDate} ${data['date']}'),
              Text('${AppLocalizations.of(context)!.bloodPressure} ${data['blood_pressure']}'),
              Text('${AppLocalizations.of(context)!.hemoglobin} ${data['hemoglobin']}'),
              Text('${AppLocalizations.of(context)!.doctorName} ${data['doctor_name']}'),
              Text('${AppLocalizations.of(context)!.bloodType} $bloodTypeDisplayName'),
              Text('${AppLocalizations.of(context)!.donorName} ${data['donor_name']}'),
              Text('${AppLocalizations.of(context)!.donatedAmount} ${data['donated_dose']}'),
              _buildCheckMarkText('${AppLocalizations.of(context)!.doseProcessed}', isProcessed),
              _buildCheckMarkText('${AppLocalizations.of(context)!.doseUsed}', isUsed),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: rowMainAxisAlignment,
          children: [
            ElevatedButton(
              onPressed: !isProcessed && !isUsed ? () {
                donationService.markDoseProcessed(documentId);
              } : null,
              style: !isProcessed && !isUsed ? doseProcessedButtonStyle : disabledButtonStyle,
              child: Text(AppLocalizations.of(context)!.processed),
            ),
            ElevatedButton(
              onPressed: isProcessed && !isUsed ? () {
                donationService.markDoseUsed(documentId);
              } : null,
              style: isProcessed && !isUsed ? doseUsedButtonStyle : disabledButtonStyle,
              child: Text(AppLocalizations.of(context)!.used),
            ),
          ],
        ),
        const SizedBox(height: sizedBoxHeight),
      ],
    );
  }

  Widget _buildCheckMarkText(String label, bool checked) {
    return Row(
      children: [
        Text(
          label,
          style: checkMarkTextStyle,
        ),
        const SizedBox(width: sizedBoxHeight),
        checked
            ? checkMarkIcon
            : const SizedBox(),
      ],
    );
  }
}

String mapBloodType(String bloodType) {
  switch (bloodType) {
    case 'A_NEGATIVE':
      return 'A-';
    case 'A_POSITIVE':
      return 'A+';
    case 'B_NEGATIVE':
      return 'B-';
    case 'B_POSITIVE':
      return 'B+';
    case 'AB_NEGATIVE':
      return 'AB-';
    case 'AB_POSITIVE':
      return 'AB+';
    case 'O_NEGATIVE':
      return 'O-';
    case 'O_POSITIVE':
      return 'O+';
    default:
      return bloodType;
  }
}