import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/bloc/login_bloc.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/screens/home_screen.dart';
import 'package:tcc_projeto_app/screens/signup_screen.dart';
import 'package:tcc_projeto_app/utils/LayoutUtils.dart';
import 'elements/email_field.dart';
import 'elements/password_field.dart';
import 'elements/login_logo.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  LoginScreen({@required this.userRepository}) : assert(userRepository != null);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc;
  AuthenticationBloc authenticationBloc;
  final emailController = new TextEditingController();
  final passController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  UserRepository get _userRepository => this.widget.userRepository;

  @override
  void initState() {
    this.authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    this.loginBloc = LoginBloc(
        userRepository: _userRepository,
        authenticationBloc: this.authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignupScreen(
                          userRepository: _userRepository,
                        )));
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
                      _showCircularProgressIndicator();
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
                          _buildLoginScreenButton()
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
  Widget _buildLoginScreenButton() {
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
                  password: this.passController.text));
            }
          },
        ));
  }

  void onSuccess() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(
              userRepository: _userRepository,
            )));
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
  Widget _showCircularProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
