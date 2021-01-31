import 'package:flutter/material.dart';

class EventNameField extends StatelessWidget {
  final eventNameController;
  final Function refreshPacient;
  final isReadOnly;

  EventNameField(
      {@required this.eventNameController,
      @required this.isReadOnly,
      @required this.refreshPacient});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.isReadOnly ? null : eventNameController,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        this.refreshPacient(this.eventNameController.text);
      },
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
