import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

class EventDateField extends StatelessWidget {
  final occupedHours;
  EventDateField(
      {@required this.occupedHours});
  @override
  Widget build(BuildContext context) {
    
    return DropdownButton(items: null, onChanged: null);
  }

  DateTimeRangePicker showTimeRangePicker() {
    return DateTimeRangePicker(
      mode: DateTimeRangePickerMode.time,
      interval: 30,
      startText: "Início",
      endText: "Fim",
      doneText: "Confirmar",
      cancelText: "Voltar",
      minimumTime: DateTime(2020, 04, 19, 08, 30),
      maximumTime: DateTime(2020, 04, 19, 18, 30),
      initialStartTime: DateTime(2020, 04, 19, 08, 30),
      initialEndTime: DateTime(2020, 04, 19, 18, 30),
    );
  }

ScrollController _initilizeController(){
  
}
  // return DatePicker.showTimePicker(context,
  //           showSecondsColumn: false, locale: LocaleType.pt);
}
