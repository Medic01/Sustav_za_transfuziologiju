import 'package:flutter/material.dart';
import '../../enums/blood_types.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'blood_type_dropdown_widget_styles.dart';

class BloodTypeDropdownWidget extends StatefulWidget {
  final ValueChanged<BloodTypes?> onChanged;
  final BloodTypes? value;

  const BloodTypeDropdownWidget({
    Key? key,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  @override
  _BloodTypeDropdownWidgetState createState() => _BloodTypeDropdownWidgetState();
}

class _BloodTypeDropdownWidgetState extends State<BloodTypeDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: topMargin10,
      child: DropdownButtonFormField<BloodTypes>(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.bloodType,
          floatingLabelStyle: floatingLabelTextStyle,
          border: const OutlineInputBorder(),
        ),
        value: widget.value,
        onChanged: widget.onChanged,
        items: BloodTypes.values.map<DropdownMenuItem<BloodTypes>>((type) {
          String displayName = type.toString().split('.').last;
          displayName = displayName
              .replaceAll('_NEGATIVE', '-')
              .replaceAll('_POSITIVE', '+');
          return DropdownMenuItem<BloodTypes>(
            value: type,
            child: Text(
              displayName,
            ),
          );
        }).toList(),
      ),
    );
  }
}
