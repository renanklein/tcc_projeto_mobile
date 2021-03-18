import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/home/screen/dashboard.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/signup_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

import 'elements/email_field.dart';
import 'elements/name_field.dart';
import 'elements/password_field.dart';

class SignupScreen extends StatefulWidget {
  final userRepository = Injector.appInstance.getDependency<UserRepository>();

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  String _accessController;

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
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSigned) {
            onSuccess();
            redirectToHomePage();
          } else if (state is SignupFailed) {
            onFail();
          }
        },
        child: BlocBuilder(
          cubit: signupBloc,
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
                  DropdownButtonFormField(
                    items: _getDropdownMenuItems(),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        this._accessController = newValue;
                      });
                    },
                  ),
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
                                  access: this._accessController,
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

  List<DropdownMenuItem> _getDropdownMenuItems() {
    final medico = DropdownMenuItem(
      value: "MEDIC",
      child: Text("Médico"),
    );

    final paciente = DropdownMenuItem(
      value: "PACIENT",
      child: Text("Paciente"),
    );

/*     final secretaria = DropdownMenuItem(
      value: "ASSISTANT",
      child: Text("Secretária"),
    ); */

    final list = <DropdownMenuItem>[];

    list.add(medico);
    list.add(paciente);
/*     list.add(secretaria);
 */
    return list;
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Conta criada com sucesso !"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void redirectToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Dashboard(),
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
