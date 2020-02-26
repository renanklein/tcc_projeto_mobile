import 'package:flutter/material.dart';

class LoginEmailField extends StatelessWidget {
  final emailController;

  LoginEmailField({@required this.emailController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        hintText: "E-mail",
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (text) {
        if (text.isEmpty || !text.contains("@")) {
          return "Email inválido";
        }
      },
    );
  }
}
