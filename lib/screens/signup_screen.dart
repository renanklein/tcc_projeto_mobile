import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/bloc/signup_bloc.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/screens/elements/email_field.dart';
import 'package:tcc_projeto_app/screens/elements/name_field.dart';
import 'package:tcc_projeto_app/screens/elements/password_field.dart';

import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  UserRepository userRepository;
  SignupScreen({@required this.userRepository})
      : assert(userRepository != null);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
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
    this.authenticationBloc.close();
    this.signupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder(
        bloc: signupBloc,
        builder: (context, state) {
          if (state is SignupInitial) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          } else {
            if(state is SignupFailed){
              onFail();
            }
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
                            this.signupBloc.add(
                              SignupButtonPressed(
                                name : this._nameController.text,
                                email : this._emailController.text,
                                password: this._passController.text
                              )
                            );

                            onSuccess(userRepository);
                          }
                        },
                      ))
                ],
              ),
            );
          }
        },
      ),
    );
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

  void onSuccess(UserRepository userRepository) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Conta criada com sucesso !"),
      backgroundColor: Colors.green,
    ));

    Future.delayed(
      Duration(seconds: 2),
    ).then((resp) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen(userRepository: userRepository,))
      );
    });
  }

  void onFail() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Falha ao criar o usuário"),
      backgroundColor: Colors.red,
    ));
  }
}
