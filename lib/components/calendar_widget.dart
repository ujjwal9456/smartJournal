import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  const CalendarWidget({
    super.key,
    required this.onDateSelected,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CalendarDatePicker(
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          onDateChanged: onDateSelected,
        ),
      ),
    );
  }
}