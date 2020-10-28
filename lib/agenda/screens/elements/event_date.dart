import 'package:flutter/material.dart';

class EventDate extends StatelessWidget {
  final selectedDay;

  EventDate({@required this.selectedDay});
  @override
  Widget build(BuildContext context) {
    return TextField(
        readOnly: true,
        obscureText: true,
        decoration: InputDecoration(
          hintText: _dayAsString(),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ));
  }

  String _dayAsString() {
    return "${this.selectedDay.day} - ${this.selectedDay.month} - ${this.selectedDay.year}";
  }
}
