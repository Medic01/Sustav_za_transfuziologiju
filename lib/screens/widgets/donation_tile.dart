import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DonationTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onReject;

  const DonationTile({
    Key? key,
    required this.data,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
          Text('${AppLocalizations.of(context)!.technicianName} ${data['technician_name']}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onReject,
            child: Text(AppLocalizations.of(context)!.rejectBtn),
          ),
        ],
      ),
    );
  }
}