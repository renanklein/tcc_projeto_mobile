import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main (){
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Projeto tcc",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey
      ),
      home: HomeScreen()
    );
  }
}