import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'blood_drop_loading_widget_style.dart';

class BloodDropLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        const SizedBox(height: sizedBoxHeight),
        Text(
          AppLocalizations.of(context)!.loading,
          style: textStyle,
        ),
      ],
    );
  }
}
