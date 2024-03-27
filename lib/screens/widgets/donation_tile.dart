import 'package:flutter/material.dart';

class DonationTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const DonationTile({
    Key? key,
    required this.data,
    this.onAccept,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Mjesto doniranja: ${data['location']}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Datum donacije: ${data['date']}'),
          Text('Tlak darivatelja ${data['blood_pressure']}'),
          Text('Hemoglobin ${data['hemoglobin']}'),
          Text('Ime doktora ${data['doctor_name']}'),
          Text('Krvna grupa darivatelja: ${data['blood_type']}'),
          Text('Ime darivatelja: ${data['donor_name']}'),
          Text('Ime tehničara: ${data['technician_name']}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: onAccept,
            child: const Text('Accept'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onReject,
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}