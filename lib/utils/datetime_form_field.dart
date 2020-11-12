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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(fieldPlaceholder),
          DateTimeField(
            controller: dateTimeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            format: DateFormat('dd-MM-yyyy'),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(2050),
                locale: Locale('pt', 'BR'),
                initialDate: currentValue ?? DateTime.parse("19700101"),
              );
            },
          ),
        ],
      ),
    );
  }
}
