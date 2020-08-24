import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
class EventDate extends StatelessWidget {
  final selectedDay;

  EventDate({@required this.selectedDay});
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      obscureText: true,
      decoration: InputDecoration(
          hintText: ConvertUtils.dayFromDateTime(this.selectedDay),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    ));
  }
}