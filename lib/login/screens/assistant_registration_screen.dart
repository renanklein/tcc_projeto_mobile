import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/signup_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

import 'elements/email_field.dart';
import 'elements/name_field.dart';
import 'elements/password_field.dart';

class AssistantRegistrationScreen extends StatefulWidget {
  final userRepository = Injector.appInstance.getDependency<UserRepository>();

  @override
  _AssistantRegistrationScreenState createState() =>
      _AssistantRegistrationScreenState();
}

class _AssistantRegistrationScreenState
    extends State<AssistantRegistrationScreen> {
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
    this.signupBloc = BlocProvider.of<SignupBloc>(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastrar Secretária"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSigned) {
            onSuccess();
          } else if (state is SignupFailed) {
            onFail();
          }
        },
        child: BlocBuilder(
          bloc: signupBloc,
          builder: (context, state) {
            if (state is SignupProcessing) {
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
                  LoginPasswordField(passController: this._passController),
                  LayoutUtils.buildVerticalSpacing(20.0),
                  SizedBox(
                    height: 44.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Theme.of(context).primaryColor,
                          textStyle: TextStyle(
                            color: Colors.white,
                          )),
                      child: Text("Criar Conta",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0)),
                      onPressed: () {
                        if (this.formKey.currentState.validate()) {
                          this.signupBloc.add(
                                SignupButtonPressed(
                                  name: this._nameController.text,
                                  email: this._emailController.text,
                                  password: this._passController.text,
                                  access: 'ASSISTANT',
                                  context: context,
                                ),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Conta criada com sucesso !"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Falha ao criar o usuário"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
