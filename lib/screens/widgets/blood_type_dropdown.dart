import 'package:flutter/material.dart';
import '../enums/blood_types.dart';

class BloodTypeDropdown extends StatefulWidget{
  final ValueChanged<BloodTypes?> onChanged;
  final BloodTypes? value;

  BloodTypeDropdown({required this.onChanged, required this.value});

  @override
  _BloodTypeDropdownState createState() => _BloodTypeDropdownState();
}

class _BloodTypeDropdownState extends State<BloodTypeDropdown> {
  BloodTypes? _selectedBloodType;

  @override
  void initState() {
    super.initState();
    _selectedBloodType = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
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