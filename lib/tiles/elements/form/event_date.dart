import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class EventDateField extends StatelessWidget {
  final eventDateController;
  EventDateField({@required this.eventDateController});
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: eventDateController,
      onShowPicker: (context, date) async {
        return showDatePicker(
            firstDate: DateTime.now(),
            initialDate: date ?? DateTime.now(),
            lastDate: DateTime(2030),
            context: context);
      },
      format: DateFormat("yyy-MM-DD"),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: "Data do evento",
      ),
    );
  }
}
