import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';

class DonationListItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;
  final DonationService donationService;
  final TextEditingController quantityController;
  final Logger logger = Logger('DonationListItem');

  DonationListItem({
    required this.data,
    required this.documentId,
    required this.donationService,
    required this.quantityController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
              '${AppLocalizations.of(context)!.donationLocation} ${data['location']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${AppLocalizations.of(context)!.donationDate} ${data['date']}'),
              Text(
                  '${AppLocalizations.of(context)!.bloodPressure} ${data['blood_pressure']}'),
              Text(
                  '${AppLocalizations.of(context)!.hemoglobin} ${data['hemoglobin']}'),
              Text(
                  '${AppLocalizations.of(context)!.doctorName} ${data['doctor_name']}'),
              Text(
                  '${AppLocalizations.of(context)!.bloodType} ${data['blood_type']}'),
              Text(
                  '${AppLocalizations.of(context)!.donorName} ${data['donor_name']}'),
              Text(
                '${AppLocalizations.of(context)!.doseProcessed} ${data['dose_processed']}',
                style: TextStyle(
                  color: data['dose_processed'] == true
                      ? Colors.green
                      : Colors.black,
                ),
              ),
              Text(
                '${AppLocalizations.of(context)!.doseUsed} ${data['dose_used']}',
                style: TextStyle(
                  color:
                      data['dose_used'] == true ? Colors.green : Colors.black,
                ),
              ),
              Text(
                '${AppLocalizations.of(context)!.donatedAmount} ${data['donated_dose'] ?? 'N/A'}',
                style: TextStyle(
                  color:
                      data['donated_dose'] == 100 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                donationService.markDoseProcessed(documentId);
              },
              child: Text(AppLocalizations.of(context)!.processed),
            ),
            ElevatedButton(
              onPressed: () {
                donationService.markDoseUsed(documentId);
              },
              child: Text(AppLocalizations.of(context)!.used),
            ),
            ElevatedButton(
              onPressed: () {
                showQuantityDialog(context);
              },
              child: Text(AppLocalizations.of(context)!.quantity),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void showQuantityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.enterDoseQuantity),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.quantity,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                String quantity = quantityController.text;
                int existingQuantity = data['donated_dose'] ?? 0;
                if (quantity.isNotEmpty &&
                    int.tryParse(quantity) != null &&
                    int.parse(quantity) >= existingQuantity &&
                    int.parse(quantity) <= 100) {
                  donationService.updateDonatedDose(
                      documentId, int.parse(quantity));
                } else if (int.parse(quantity) < existingQuantity) {
                  logger.info(
                      'You cannot enter a quantity less than the existing one');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!.setMinQuantity),
                  ));
                } else {
                  logger.info('Invalid quantity input');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.setMinMaxQuantity),
                  ));
                }
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }
}
