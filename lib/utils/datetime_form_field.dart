import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class DateTimeFormField extends StatelessWidget {
  final dateTimeController;
  final fieldPlaceholder;

  DateTimeFormField(
      {@required this.dateTimeController, @required this.fieldPlaceholder});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DateTimeField(
          controller: dateTimeController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              hintText: fieldPlaceholder),
          format: DateFormat('dd-MM-yyyy'),
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2050),
              locale: Locale('pt', 'BR'),
              initialDate: DateTime.now(),
            );
          },
        ),
      ],
    );
  }
}
