import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/bloc/signup_bloc.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

import 'elements/email_field.dart';
import 'elements/name_field.dart';
import 'elements/password_field.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  final userRepository = Injector.appInstance.getDependency<UserRepository>();

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  AuthenticationBloc authenticationBloc;
  SignupBloc signupBloc;

  UserRepository get userRepository => this.widget.userRepository;

  @override
  void initState() {
    this.authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    this.signupBloc = SignupBloc(
        userRepository: userRepository,
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
          title: Text("Criar Conta"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocProvider(
          create: (context) => this.signupBloc,
          child: BlocListener<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state is SignupSigned) {
                  onSuccess();
                  redirectToHomePage();
                } else if (state is SignupFailed) {
                  onFail();
                }
              },
              child: BlocBuilder(
                  bloc: signupBloc,
                  builder: (context, state) {
                    if(state is SignupProcessing){
                      return LayoutUtils.buildCircularProgressIndicator(context);
                    }
                    return Form(
                      key: formKey,
                      child: ListView(
                        padding: EdgeInsets.all(16.0),
                        children: <Widget>[
                          LayoutUtils.buildVerticalSpacing(20.0),
                          LoginNameField(
                            nameController: this._nameController,
                          ),
                          LayoutUtils.buildVerticalSpacing(20.0),
                          LoginEmailField(
                            emailController: this._emailController,
                          ),
                          LayoutUtils.buildVerticalSpacing(20.0),
                          LoginPasswordField(
                              passController: this._passController),
                          LayoutUtils.buildVerticalSpacing(20.0),
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
                          LayoutUtils.buildVerticalSpacing(20.0),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                onPressed: () {
                                  if (this.formKey.currentState.validate()) {
                                    this.signupBloc.add(SignupButtonPressed(
                                        name: this._nameController.text,
                                        email: this._emailController.text,
                                        password: this._passController.text));
                                  }
                                },
                              ))
                        ],
                      ),
                    );
                  })),
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
    this.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Conta criada com sucesso !"),
          backgroundColor: Colors.green,
        ));
  }

  void redirectToHomePage() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void onFail() {
    this.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Falha ao criar o usuário"),
          backgroundColor: Colors.red,
      ));
  }
}
