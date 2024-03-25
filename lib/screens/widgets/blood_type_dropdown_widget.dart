import 'package:flutter/material.dart';
import '../enums/blood_types.dart';

class BloodTypeDropdownWidget extends StatefulWidget{
  final ValueChanged<BloodTypes?> onChanged;
  final BloodTypes? value;

  const BloodTypeDropdownWidget({super.key, required this.onChanged, required this.value});

  @override
  _BloodTypeDropdownWidgetState createState() => _BloodTypeDropdownWidgetState();
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
      margin: const EdgeInsets.only(top: 10.0),
      child: DropdownButtonFormField<BloodTypes>(
        decoration: const InputDecoration(
          labelText: 'Blood Type',
          border: OutlineInputBorder(),
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
            child: Text(type.toString().split('.').last),
          );
        }).toList(),
      ),
    );
  }
}