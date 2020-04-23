import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

class EventHourField extends StatefulWidget {
  final occupedHours;
  final eventHour;
  EventHourField({@required this.occupedHours, @required this.eventHour});

  @override
  _EventHourFieldState createState() => _EventHourFieldState();
}

class _EventHourFieldState extends State<EventHourField> {
  List<String> get occupedHours => this.widget.occupedHours;
  String get eventHour => this.widget.eventHour;

  @override
  Widget build(BuildContext context) {
    
    var currentValue = this.eventHour == null ? _getTotalHours().first : this.eventHour;

    return DropdownButtonFormField(
        hint: Text("-- Selecione um horário --"),
        value: currentValue,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        items: _getAvailableHours().map((hour) {
          return DropdownMenuItem(
            value: hour,
            child: Text(hour),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            currentValue = newValue;
          });
        });
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

  ScrollController _initilizeController() {}

  List<String> _getTotalHours() {
    return <String>[
      "08:00 - 08:30"
          "08:30 - 09:00"
          "09:00 - 09:30"
          "09:30 - 10:00"
          "10:00 - 10:30"
          "10:30 - 11:00"
          "11:00 - 11:30"
          "11:30 - 12:00"
          "12:00 - 12:30"
          "12:30 - 13:00"
          "13:00 - 13:30"
          "13:30 - 14:00"
          "14:00 - 14:30"
          "14:30 - 15:00"
          "14:00 - 14:30"
          "14:30 - 15:00"
          "14:00 - 14:30"
          "14:30 - 15:00"
          "15:00 - 15:30"
          "15:30 - 16:00"
          "16:00 - 16:30"
          "16:30 - 17:00"
          "17:00 - 17:30"
          "17:30 - 18:00"
          "18:00 - 18:30"
          "18:30 - 19:00"
    ];
  }

  List<String> _getAvailableHours() {
    var totalHours = _getTotalHours();

    totalHours.remove(this.widget.occupedHours);

    return totalHours;
  }
}
