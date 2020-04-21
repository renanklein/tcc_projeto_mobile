import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

class EventDateField extends StatelessWidget {
  final eventDateController;
  final eventHint;
  EventDateField(
      {@required this.eventDateController, @required this.eventHint});
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: eventDateController,
      onShowPicker: (context, date) async {
        return DatePicker.showTimePicker(context,
            showSecondsColumn: false, locale: LocaleType.pt);
      },
      format: DateFormat("HH:mm"),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        hintText: this.eventHint,
      ),
    );
  }
}
