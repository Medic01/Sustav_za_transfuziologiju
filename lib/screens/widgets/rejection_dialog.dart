import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RejectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String rejectionReason = '';

    return AlertDialog(
      title: const Text('Unesite razlog odbijanja: '),
      content: TextField(
        onChanged: (value) {
          rejectionReason = value;
        },
        decoration: const InputDecoration(
          hintText: 'Razlog...',
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(rejectionReason.trim());
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}