import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_projeto_app/models/user_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tcc_projeto_app/screens/login_screen.dart';

import 'model/agenda_model.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return ScopedModel<AgendaModel>(
            model: AgendaModel(user: model.user),
            child: MaterialApp(
              title: "Projeto tcc",
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primaryColor: Colors.blueGrey),
              home: LoginScreen(),
            ),
          );
        }));
  }
}
