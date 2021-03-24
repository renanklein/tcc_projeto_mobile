import 'package:flutter/material.dart';

class LoginPasswordField extends StatelessWidget {
  final passController;

  LoginPasswordField({@required this.passController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        hintText: "Senha",
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (text) {
        if (text.isEmpty) {
          return "Senha inválida";
        }
        return null;
      },
    );
  }
}
