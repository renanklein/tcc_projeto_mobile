import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_projeto_app/models/user_model.dart';
import 'package:tcc_projeto_app/screens/elements/email_field.dart';
import 'package:tcc_projeto_app/screens/elements/name_field.dart';
import 'package:tcc_projeto_app/screens/elements/password_field.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            } else {
              return Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    LoginNameField(
                      nameController: this._nameController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    LoginEmailField(
                      emailController: this._emailController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    LoginPasswordField(passController: this._passController),
                    SizedBox(
                      height: 20.0,
                    ),
                    DropdownButtonFormField(
                      items: _getDropdownMenuItems(),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                      onChanged: (_) {},
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                        height: 44.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text("Criar Conta",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                          onPressed: () {
                            if (this.formKey.currentState.validate()) {
                              Map<String, dynamic> userData = {
                                "email": this._emailController.text,
                                "name": this._nameController.text
                              };
                              model.signUp(
                                  pass: this._passController.text,
                                  userDados: userData,
                                  onSuccess: onSuccess,
                                  onFail: onFail);
                            }
                          },
                        ))
                  ],
                ),
              );
            }
          },
        ));
  }

  List<DropdownMenuItem> _getDropdownMenuItems() {
    final medico = DropdownMenuItem(
      child: Text("Médico"),
    );

    final paciente = DropdownMenuItem(child: Text("Paciente"));

    final list = List<DropdownMenuItem>();

    list.add(medico);
    list.add(paciente);

    return list;
  }

  void onSuccess() {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Conta criada com sucesso !"),
      backgroundColor: Colors.green,
    ));

    Future.delayed(
      Duration(seconds: 2),
    ).then((resp) {
      Navigator.of(context).pop();
    });
  }

  void onFail() {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar o usuário"),
      backgroundColor: Colors.red,
    ));
  }
}
