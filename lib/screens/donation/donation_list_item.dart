import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';

class DonationListItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;
  final DonationService donationService;
  final TextEditingController quantityController;
  
  const DonationListItem({
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
          title: Text('Donation location: ${data['location']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Donation date: ${data['date']}'),
              Text('Donor blood pressure: ${data['blood_pressure']}'),
              Text('Hemoglobin: ${data['hemoglobin']}'),
              Text('Doctor name: ${data['doctor_name']}'),
              Text('Blood type: ${data['blood_type']}'),
              Text('Donor name: ${data['donor_name']}'),
              Text(
                'Blood processed: ${data['dose_processed']}',
                style: TextStyle(
                  color: data['dose_processed'] == true ? Colors.green : Colors.black,
                ),
              ),
              Text(
                'Blood used: ${data['dose_used']}',
                style: TextStyle(
                  color: data['dose_used'] == true ? Colors.green : Colors.black,
                ),
              ),
              Text(
                'Donated dose quantity: ${data['donated_dose'] ?? 'N/A'}',
                style: TextStyle(
                  color: data['donated_dose'] == 100 ? Colors.red : Colors.green,
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
              child: const Text('Processed'),
            ),
            ElevatedButton(
              onPressed: () {
                donationService.markDoseUsed(documentId);
              },
              child: const Text('Used'),
            ),
            ElevatedButton(
              onPressed: () {
                showQuantityDialog(context);
              },
              child: const Text('Quantity'),
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
          title: const Text('Enter donated dose quantity'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
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
                      documentId,
                      int.parse(quantity)
                  );
                  
                } else if (int.parse(quantity) < existingQuantity) {
                  print('You cannot enter a quantity less than the existing one');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('You cannot enter a quantity less than the existing one'),
                  ));
                } else {
                  print('Invalid quantity input');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Quantity must be between $existingQuantity and 100'),
                  ));
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
