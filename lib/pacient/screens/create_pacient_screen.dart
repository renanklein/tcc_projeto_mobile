import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/utils/dialog_utils/dialog_widgets.dart';

class CreatePacientScreen extends StatefulWidget {
  final String path;

  CreatePacientScreen({this.path});

  @override
  _CreatePacientScreenState createState() => _CreatePacientScreenState();
}

class _CreatePacientScreenState extends State<CreatePacientScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  UserModel _userModel;

  String get getPath => this.widget.path;

  String sexoController = 'Masculino';
  String tipoDocumentoController = 'RG';
  List<String> tipoDocumentoList = [
    'RG',
    'Carteira de Trabalho',
    'Carteira Profissional',
    'Passaporte',
    'Carteira Funcional'
  ];

  final userRepository = Injector.appInstance.getDependency<UserRepository>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _createPacientFormKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final identidadeController = TextEditingController();
  final cpfController = TextEditingController();
  final dtNascController = TextEditingController();

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
    super.dispose();
  }

  Future<void> _setUserModel() async {
    this._userModel = await this.userRepository.getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              Navigator.pushReplacementNamed(context, '/');
            } else if (state is CreatePacientEventSuccess) {
              Scaffold.of(context).showSnackBar(messageSnackBar(
                context,
                "Paciente Cadastrado com Sucesso",
                Colors.green,
                Colors.white,
              ));
              if (this.getPath == preDiagnosisRoute) {
                Navigator.pushReplacementNamed(
                  context,
                  preDiagnosisRoute,
                  arguments: state.pacientCreated,
                );
              }
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
                  key: _createPacientFormKey,
                  child: Center(
                    child: Container(
                      //decoration: new BoxDecoration(color: Colors.black54),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                pacienteFormField(
                                  nomeController,
                                  'Nome:',
                                  'Insira o nome do paciente',
                                  'Por Favor, insira o nome do paciente',
                                ),
                                pacienteFormField(
                                  emailController,
                                  'E-mail:',
                                  'Insira o e-mail do paciente',
                                  'Por Favor, insira um e-mail válido',
                                ),
                                InternationalPhoneNumberInput(
                                  initialValue: PhoneNumber(
                                    phoneNumber: '21',
                                    dialCode: '+55',
                                    isoCode: 'BR',
                                  ),
                                  onInputChanged: (phone) {},
                                  inputDecoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 10.0, 20.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0)),
                                      hintText: "Telefone"),
                                  textFieldController: this.telefoneController,
                                ),
                                Column(
                                  children: [
                                    Text('Tipo de Documento'),
                                    DropdownButton<String>(
                                      hint: Text(
                                          'Selecione o tipo de documento apresentado'),
                                      items: tipoDocumentoList
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          this.tipoDocumentoController =
                                              newValue;
                                        });
                                      },
                                      value: tipoDocumentoController,
                                    ),
                                  ],
                                ),
                                pacienteFormField(
                                  identidadeController,
                                  'Nº Doc:',
                                  'Insira o número do Documento do paciente',
                                  'Por Favor, insira um número válido',
                                ),
                                pacienteFormField(
                                  cpfController,
                                  'CPF:',
                                  'Insira o CPF do paciente',
                                  'Por Favor, insira um CPF válido',
                                ),
                                Column(
                                  children: [
                                    Text('Sexo do Paciente'),
                                    DropdownButton<String>(
                                      hint:
                                          Text('Selecione o sexo do paciente'),
                                      items: [
                                        'Masculino',
                                        'Feminino',
                                        'Não Declarado'
                                      ].map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          this.sexoController = newValue;
                                        });
                                      },
                                      value: sexoController,
                                    ),
                                  ],
                                ), //menudropdown
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
                                      if (_createPacientFormKey.currentState
                                              .validate() &&
                                          sexoController != '') {
                                        await _setUserModel();

                                        //TODO: check se necessita ir pro pré-atendimento

                                        _pacientBloc.add(
                                          PacientCreateButtonPressed(
                                            userId: _userModel.uid,
                                            nome: nomeController.text,
                                            email: emailController.text,
                                            telefone: telefoneController.text,
                                            identidade:
                                                tipoDocumentoController +
                                                    ': ' +
                                                    identidadeController.text,
                                            cpf: cpfController.text,
                                            dtNascimento: dtNascController.text,
                                            sexo: sexoController,
                                          ),
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
            }
          }),
        ),
      ),
    );
  }
}

Widget pacienteFormField(controller, label, hint, errorText) {
  var mask = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      inputFormatters: label == "CPF:" ? [mask] : null,
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
