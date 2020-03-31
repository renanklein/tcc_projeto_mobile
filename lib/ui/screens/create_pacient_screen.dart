import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/ui/screens/login_screen.dart';
import 'package:tcc_projeto_app/ui/widget/drawer.dart';

class CreatePacient extends StatefulWidget {
  @override
  _CreatePacientState createState() => _CreatePacientState();
}

class _CreatePacientState extends State<CreatePacient> {
  UserModel model;
  AuthenticationBloc _authenticationBloc;

  final _createPacientKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();
  final cpfController = TextEditingController();
  final dtNascController = TextEditingController();
  final sexoController = TextEditingController();
  final vinculoController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    idController.dispose();
    cpfController.dispose();
    dtNascController.dispose();
    sexoController.dispose();
    vinculoController.dispose();
    super.dispose();
  }

  //UserRepository get userRepository => this.widget.userRepository;

  @override
  void initState() {
    this._authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => this._authenticationBloc,
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationUnauthenticated) {
            return LoginScreen();
          }
        },
        child: BlocBuilder(
          bloc: this._authenticationBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Cadastrar Paciente"),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
              ),
              drawer: UserDrawer(),
              body: SafeArea(
                child: Form(
                  key: _createPacientKey,
                  child: Center(
                    child: Container(
                      //decoration: new BoxDecoration(color: Colors.black54),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListView(
                            children: <Widget>[
                              PacienteFormField(
                                nomeController,
                                'Nome:',
                                'Insira o nome do paciente',
                                'Por Favor, insira um nome',
                              ),
                              PacienteFormField(
                                emailController,
                                'E-mail:',
                                'Insira o e-mail do paciente',
                                'Por Favor, insira um e-mail válido',
                              ),
                              PacienteFormField(
                                idController,
                                'Identidade:',
                                'Insira o número do RG do paciente',
                                'Por Favor, insira um e-mail válido',
                              ),
                              PacienteFormField(
                                cpfController,
                                'CPF:',
                                'Insira o CPF do paciente',
                                'Por Favor, insira um CPF válido',
                              ),
                              PacienteFormField(
                                sexoController,
                                'Sexo:',
                                'Selecione o sexo do paciente',
                                '',
                              ),
                              DateField('Data de Nascimento:', dtNascController),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  color: Color(0xFF84FFFF),
                                  height: 55.0,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                  ),
                                  onPressed: () {
                                    if (_createPacientKey.currentState
                                        .validate()) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(nomeController.text),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Text('Cadastrar Paciente'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget PacienteFormField(controller, label, hint, errorText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        labelText: label,
        hintText: hint,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return errorText;
        }
        return null;
      },
    ),
  );
}

Widget DateField(label, controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        Text(label),
        DateTimeField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          format: DateFormat('dd-MM-yyyy'),
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2050),
              //locale: Locale('pt', 'BR'),
              initialDate: currentValue ?? DateTime.parse("19700101"),              
            );
          },
        ),
      ],
    ),
  );
}
