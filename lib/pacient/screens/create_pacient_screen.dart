import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';

class CreatePacientScreen extends StatefulWidget {
  @override
  _CreatePacientScreenState createState() => _CreatePacientScreenState();
}

class _CreatePacientScreenState extends State<CreatePacientScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  UserModel _userModel;

  final userRepository = Injector.appInstance.getDependency<UserRepository>();

  final formKey = new GlobalKey<FormState>();

  final _createPacientKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final identidadeController = TextEditingController();
  final cpfController = TextEditingController();
  final dtNascController = TextEditingController();
  final sexoController = TextEditingController();

  @override
  void initState() {
    var injector = Injector.appInstance;
    this._pacientRepository = injector.getDependency<PacientRepository>();

    this._pacientBloc = new PacientBloc(
      pacientRepository: this._pacientRepository,
    );

    super.initState();
  }

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

  Future<void> _setUserModel() async {
    this._userModel = await this.userRepository.getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Paciente"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider<PacientBloc>(
        create: (context) => this._pacientBloc,
        child: BlocListener<PacientBloc, PacientState>(
          listener: (context, state) {
            if (state is AuthenticationUnauthenticated) {
              Navigator.pushNamed(context, '/');
            }
          },
          child:
              BlocBuilder<PacientBloc, PacientState>(builder: (context, state) {
            if (state is CreatePacientEventProcessing) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              return SafeArea(
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
                              pacienteFormField(
                                nomeController,
                                'Nome:',
                                'Insira o nome do paciente',
                                'Por Favor, insira um nome',
                              ),
                              pacienteFormField(
                                emailController,
                                'E-mail:',
                                'Insira o e-mail do paciente',
                                'Por Favor, insira um e-mail válido',
                              ),
                              pacienteFormField(
                                telefoneController,
                                'Tel.:',
                                'Insira o número do telefone do paciente',
                                'Por Favor, insira um número válido',
                              ),
                              pacienteFormField(
                                identidadeController,
                                'Identidade:',
                                'Insira o número do RG do paciente',
                                'Por Favor, insira um e-mail válido',
                              ),
                              pacienteFormField(
                                cpfController,
                                'CPF:',
                                'Insira o CPF do paciente',
                                'Por Favor, insira um CPF válido',
                              ),
                              //menudropdown
                              pacienteFormField(
                                sexoController,
                                'Sexo:',
                                'Selecione o sexo do paciente',
                                '',
                              ),
                              dateFormField(
                                dtNascController,
                                'Data de Nascimento:',
                                'Entre com a Data de Nascimento',
                                context,
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
                                      await _setUserModel();

                                      _pacientBloc.add(
                                        PacientCreateButtonPressed(
                                          userId: _userModel.uid,
                                          nome: nomeController.text,
                                          email: emailController.text,
                                          telefone: telefoneController.text,
                                          identidade: identidadeController.text,
                                          cpf: cpfController.text,
                                          dtNascimento: dtNascController.text,
                                          sexo: sexoController.text,
                                        ),
                                      );
                                      if (state is CreatePacientEventSuccess) {
                                        _buildSuccessSnackBar(context);
                                      }
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
              );
            }
          }),
        ),
      ),
    );
  }
}

void _buildSuccessSnackBar(context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(
      "Paciente Cadastrado com Sucesso",
      style: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
    ),
  ));
}

Widget pacienteFormField(controller, label, hint, errorText) {
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

Widget dateFormField(controller, label, hint, contexto) {
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
      onTap: () async {
        final DateTime datePicked = await showDatePicker(
            context: contexto,
            initialDate: new DateTime(1960),
            firstDate: new DateTime(1890),
            lastDate: new DateTime.now());
        var dateFormat = DateFormat("dd/MM/yyyy");
        if (datePicked != null) controller.text = dateFormat.format(datePicked);
      },
      validator: (value) {
        if (value.isEmpty) {
          controller.text = '';
          return 'Por Favor, escolha uma data.';
        }
        return null;
      },
    ),
  );
}

Widget dateField(label, controller) {
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
