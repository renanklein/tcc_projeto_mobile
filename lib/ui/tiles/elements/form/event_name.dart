import 'package:flutter/material.dart';

class EventNameField extends StatelessWidget {
  final eventNameController;

  EventNameField({@required this.eventNameController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: eventNameController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: "Nome do evento"),
    );
  }
}
