import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/screens/login_screen.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Projeto tcc",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: LoginScreen()
    );
  }
}