import 'package:flutter/material.dart';

class LoginNameField extends StatelessWidget {
  final nameController;

  LoginNameField({@required this.nameController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        hintText: "Nome Completo",
      ),
    );
  }
}
