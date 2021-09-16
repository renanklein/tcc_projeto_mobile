import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class DateTimeFormField extends StatelessWidget {
  final dateTimeController;
  final fieldPlaceholder;
  final solicitationDate;
  final Function onSelectedDate;

  DateTimeFormField(
      {@required this.dateTimeController,
      @required this.fieldPlaceholder,
      this.solicitationDate,
      this.onSelectedDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DateTimeField(
          onChanged: (value) {
            if (this.onSelectedDate != null) {
              this.onSelectedDate(value);
            }
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
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              hintText: fieldPlaceholder,
              floatingLabelBehavior: FloatingLabelBehavior.auto),
          format: DateFormat('dd/MM/yyyy'),
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: this.solicitationDate != null ? this._getLastDate() : DateTime(2050),
              locale: Locale('pt', 'BR'),
              initialDate: DateTime.now(),
            );
          },
        ),
      ],
    );
  }

   DateTime _getLastDate(){
    if(DateTime.now().isAfter(this.solicitationDate)){
      return DateTime.now();
    }

    return this.solicitationDate;
  }
}
