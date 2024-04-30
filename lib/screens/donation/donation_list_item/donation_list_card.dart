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
              Text('${AppLocalizations.of(context)!.bloodType} ${data['blood_type']}'),
              Text('${AppLocalizations.of(context)!.donorName} ${data['donor_name']}'),
              Text('${AppLocalizations.of(context)!.donatedAmount} ${data['donated_dose']}'),
              _buildCheckMarkText('${AppLocalizations.of(context)!.doseProcessed}', data['dose_processed'] == true),
              _buildCheckMarkText('${AppLocalizations.of(context)!.doseUsed}', data['dose_used'] == true),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: rowMainAxisAlignment,
          children: [
            ElevatedButton(
              onPressed: () {
                donationService.markDoseProcessed(documentId);
              },
              style: doseProcessedButtonStyle,
              child: Text(AppLocalizations.of(context)!.processed),
            ),
            ElevatedButton(
              onPressed: () {
                donationService.markDoseUsed(documentId);
              },
              style: doseUsedButtonStyle,
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