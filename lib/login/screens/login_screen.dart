import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/home/screen/home_screen.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/login_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/login/screens/signup_screen.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'elements/email_field.dart';
import 'elements/password_field.dart';
import 'elements/login_logo.dart';


class LoginScreen extends StatefulWidget {
  final userRepository = Injector.appInstance.getDependency<UserRepository>();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc;
  final emailController = new TextEditingController();
  final passController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    this.loginBloc = Injector.appInstance.getDependency<LoginBloc>();
    super.initState();
  }

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
        body: BlocProvider(
          create: (context) => this.loginBloc,
          child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSucceded) {
                  onSuccess();
                } else if (state is LoginFailure) {
                  onFail();
                }
              },
              child: BlocBuilder<LoginBloc, LoginState>(
                  bloc: this.loginBloc,
                  builder: (context, state) {
                    if (state is LoginProcessing) {
                      return LayoutUtils.buildCircularProgressIndicator(
                          context);
                    }
                    return Form(
                      key: formKey,
                      child: ListView(
                        padding: EdgeInsets.all(16.0),
                        children: <Widget>[
                          LayoutUtils.buildVerticalSpacing(20.0),
                          LoginLogo(),
                          LayoutUtils.buildVerticalSpacing(20.0),
                          LoginEmailField(
                              emailController: this.emailController),
                          LayoutUtils.buildVerticalSpacing(20.0),
                          LoginPasswordField(
                              passController: this.passController),
                          _buildForgetPasswordFlatButton(),
                          LayoutUtils.buildVerticalSpacing(20.0),
                          _buildLoginScreenButton(context)
                        ],
                      ),
                    );
                  })),
        ));
  }

  Widget _buildForgetPasswordFlatButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(
          "Esqueci minha senha",
          textAlign: TextAlign.right,
        ),
        padding: EdgeInsets.zero,
        onPressed: () {
          this.loginBloc.add(LoginResetPasswordButtonPressed(
              email: this.emailController.text));
        },
      ),
    );
  }

  Widget _buildLoginScreenButton(BuildContext context) {
    return SizedBox(
        height: 44.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text("Entrar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          onPressed: () {
            if (formKey.currentState.validate()) {
              this.loginBloc.add(LoginButtonPressed(
                  email: this.emailController.text,
                  password: this.passController.text,
                  context: context));
            }
          },
        ));
  }

  void onSuccess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void onFail() {
    this.scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Falha ao autenticar, verifique os dados informados",
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}
