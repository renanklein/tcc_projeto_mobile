import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EventDateField extends StatelessWidget {
  final eventDateController;
  EventDateField({@required this.eventDateController});
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: eventDateController,
      onShowPicker: (context, date) async {
        return DatePicker.showTimePicker(
          context,
          showSecondsColumn: false,
          locale: LocaleType.pt
        );
      },
      format: DateFormat("HH:mm"),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: "Data do evento",
      ),
    );
  }
}
