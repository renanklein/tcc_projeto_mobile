import 'package:flutter/material.dart';

class EventStatus extends StatelessWidget {
  final eventStatus;

  EventStatus({@required this.eventStatus});

  @override
  Widget build(BuildContext context) {
    return TextField(
        readOnly: true,
        obscureText: true,
        decoration: InputDecoration(
            hintText: _statusToPtBr(),
            contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
  }

  String _statusToPtBr() {
    return this.eventStatus == "created" ? "Agendado" : "Confirmado";
  }
}
