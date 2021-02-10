import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final textController;
  final fieldPlaceholder;

  Field({@required this.textController, @required this.fieldPlaceholder});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      validator: (value) {
        if (value.isEmpty) {
          return "Este campo não foi preenchido";
        }

        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: fieldPlaceholder),
    );
  }
}
