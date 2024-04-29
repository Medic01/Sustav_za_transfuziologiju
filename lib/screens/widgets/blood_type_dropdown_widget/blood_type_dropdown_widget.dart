import 'package:flutter/material.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/blood_type_dropdown_widget/blood_type_dropdown_widget_sign.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/blood_type_dropdown_widget/blood_type_dropdown_widget_styles.dart';
import '../../enums/blood_types.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodTypeDropdownWidget extends StatefulWidget {
  final ValueChanged<BloodTypes?> onChanged;
  final BloodTypes? value;

  const BloodTypeDropdownWidget({
    super.key,
    required this.onChanged,
    required this.value,
  });

  @override
  _BloodTypeDropdownWidgetState createState() =>
      _BloodTypeDropdownWidgetState();
}

class _BloodTypeDropdownWidgetState extends State<BloodTypeDropdownWidget> {
  BloodTypes? _selectedBloodType;

  @override
  void initState() {
    super.initState();
    _selectedBloodType = widget.value;
  }

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
        value: _selectedBloodType,
        onChanged: (BloodTypes? newValue) {
          setState(() {
            _selectedBloodType = newValue;
          });
          widget.onChanged(newValue);
        },
        items: BloodTypes.values.map<DropdownMenuItem<BloodTypes>>((type) {
          return DropdownMenuItem<BloodTypes>(
            value: type,
            child: Text(
              getBloodTypeDisplayName(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}
