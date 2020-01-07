import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_projeto_app/models/user_model.dart';
import 'package:tcc_projeto_app/screens/home_screen.dart';
import 'package:tcc_projeto_app/screens/signup_screen.dart';
import 'elements/email_field.dart';
import 'elements/password_field.dart';
import 'elements/login_logo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = new TextEditingController();
  final passController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Criar Conta",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              },
            )
          ],
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
                    LoginLogo(),
                    SizedBox(
                      height: 20.0,
                    ),
                    LoginEmailField(emailController: this.emailController),
                    SizedBox(
                      height: 20.0,
                    ),
                    LoginPasswordField(passController: this.passController),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        child: Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Text(
                                "Foi enviado um formulário de mudança de senha para o email cadastrado"),
                          ));
                        },
                      ),
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
                          child: Text("Entrar",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              model.signIn(
                                  email: this.emailController.text,
                                  pass: this.passController.text,
                                  onSuccess: onSuccess,
                                  onFail: onFail);
                            }
                          },
                        )),
                  ],
                ),
              );
            }
          },
        ));
  }

  void onSuccess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void onFail(){
    this.scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        "Falha ao autenticar, verifique os dados informados",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontWeight: FontWeight.w500
        ),
      ),
    ));
  }
}
