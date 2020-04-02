import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/bloc/pacient_bloc.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/repository/pacient_repository.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/ui/screens/login_screen.dart';
import 'package:tcc_projeto_app/ui/widget/drawer.dart';

class CreatePacientScreen extends StatefulWidget {  
  final pacientRepository;

  CreatePacientScreen({
    @required this.pacientRepository,
  });

  @override
  _CreatePacientScreenState createState() => _CreatePacientScreenState();
}

class _CreatePacientScreenState extends State<CreatePacientScreen> {
  UserModel model;
  AuthenticationBloc _authenticationBloc;
  PacientBloc pacientBloc;
  UserRepository _userRepository;

  final formKey = new GlobalKey<FormState>();

  final _createPacientKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final identidadeController = TextEditingController();
  final cpfController = TextEditingController();
  final dtNascController = TextEditingController();
  final sexoController = TextEditingController();

  //String get uid => this.widget.uid;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    identidadeController.dispose();
    cpfController.dispose();
    dtNascController.dispose();
    sexoController.dispose();
    super.dispose();
  }

  PacientRepository get pacientRepository => this.widget.pacientRepository;

  @override
  void initState() {
    this._authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    this.pacientBloc =
        new PacientBloc(pacientRepository: this.pacientRepository);
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
                                telefoneController,
                                'Tel.:',
                                'Insira o número do telefone do paciente',
                                'Por Favor, insira um número válido',
                              ),
                              PacienteFormField(
                                identidadeController,
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
                              DateFormField(
                                dtNascController,
                                'Data de Nascimento:',
                                'Entre com a Data de Nascimento',
                                'Digite apenas números sem espaços (DiaMêsAno)',
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  color: Color(0xFF84FFFF),
                                  height: 55.0,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                  ),
                                  onPressed: () async {
                                    if (_createPacientKey.currentState
                                        .validate()) {
                                      var user =
                                          await this._userRepository.getUser();
                                      pacientRepository.createPacient(
                                        userId: user.uid,
                                        nome: nomeController.text,
                                        email: emailController.text,
                                        telefone: telefoneController.text,
                                        identidade: identidadeController.text,
                                        cpf: cpfController.text,
                                        dtNascimento: dtNascController.text,
                                        sexo: sexoController.text,
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

Widget DateFormField(controller, label, hint, errorText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        labelText: label,
        hintText: hint,
      ),
      onChanged: (value) {
        if (value.length >= 8) {
          if (!validateData(value)) {
            controller.text = '';
            return errorText;
          }
          String data = controller.text;
          String novaData =
              '${data.substring(0, 2)}/${data.substring(2, 4)}/${data.substring(4, 8)}';
          controller.text = novaData;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          controller.text = '';
          return errorText;
        }
        return null;
      },
    ),
  );
}

bool validateData(String value) {
  if (value.length > 10) {
    return false;
  } else if (int.parse(value.substring(0, 2)) < 1 ||
      int.parse(value.substring(0, 2)) > 31) {
    return false;
  } else if (int.parse(value.substring(2, 4)) < 1 ||
      int.parse(value.substring(2, 4)) > 12) {
    return false;
  } else if (int.parse(value.substring(4, 8)) < 1900 ||
      int.parse(value.substring(2, 4)) > DateTime.now().year) {
    return false;
  } else {
    return true;
  }
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
