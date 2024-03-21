import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final TextEditingController controller;

  DatePickerWidget({required this.controller});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day, DateTime.now().hour, DateTime.now().minute);
        widget.controller.text = _selectedDate.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            labelText: 'Date',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
