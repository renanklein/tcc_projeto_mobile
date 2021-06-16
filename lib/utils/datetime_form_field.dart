import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class DateTimeFormField extends StatelessWidget {
  final dateTimeController;
  final fieldPlaceholder;
  final Function onSelectedDate;

  DateTimeFormField(
      {@required this.dateTimeController, @required this.fieldPlaceholder, this.onSelectedDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DateTimeField(
          onChanged: (value){
            this.onSelectedDate();
          },
          controller: dateTimeController,
          validator: (value) {
            if (value == null) {
              return "Não foi selecionada uma data";
            }

            return null;
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              hintText: fieldPlaceholder,
              floatingLabelBehavior:  FloatingLabelBehavior.auto),
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
