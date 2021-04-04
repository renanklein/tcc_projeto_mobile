import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReadonlyTextField extends StatelessWidget {
  final String placeholder;
  final String value;

  ReadonlyTextField({@required this.placeholder, @required this.value});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: "${this.placeholder}: ${this.value}",
      textInputAction: TextInputAction.next,
      readOnly: true,
      keyboardType: TextInputType.multiline,
      decoration: _buildFieldDecoration(),
    );
  }

  InputDecoration _buildFieldDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    );
  }
}
