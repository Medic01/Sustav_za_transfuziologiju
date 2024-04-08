import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RejectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String rejectionReason = '';

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.rejection),
      content: TextField(
        onChanged: (value) {
          rejectionReason = value;
        },
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.rejectionReason,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(rejectionReason.trim());
          },
          child: Text(AppLocalizations.of(context)!.submitBtn),
        ),
      ],
    );
  }
}