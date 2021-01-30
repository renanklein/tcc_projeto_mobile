import 'package:flutter/material.dart';

class EventNameField extends StatelessWidget {
  final eventNameController;
  final isReadOnly;

  EventNameField(
      {@required this.eventNameController, @required this.isReadOnly});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.isReadOnly ? null : eventNameController,
      readOnly: this.isReadOnly,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: this.isReadOnly
              ? this.eventNameController.text
              : "Nome do paciente"),
    );
  }
}
