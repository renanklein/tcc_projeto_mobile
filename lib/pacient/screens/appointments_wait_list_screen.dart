import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/createPreDiagnosisArguments.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/pacient/tiles/appointment_tile.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

import '../blocs/pacient_bloc.dart';

class AppointmentsWaitListScreen extends StatefulWidget {
  String userUid;

  AppointmentsWaitListScreen({@required this.userUid});
  @override
  _AppointmentsWaitListScreenState createState() =>
      _AppointmentsWaitListScreenState();
}

class _AppointmentsWaitListScreenState
    extends State<AppointmentsWaitListScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  AppointmentModel _appointmentModel;
  List<AppointmentModel> _appointmentList;

  String get userUid => this.widget.userUid;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._pacientRepository = injector.get<PacientRepository>();
    this._pacientRepository.userId = this.userUid;
    this._pacientBloc =
        new PacientBloc(pacientRepository: this._pacientRepository);

    _loadAppointments();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Atendimentos Futuros"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider<PacientBloc>(
        create: (context) => this._pacientBloc,
        child: BlocListener<PacientBloc, PacientState>(
          listener: (context, state) {
            if (state is AppointmentLoadEventSuccess) {
              _appointmentList = state.appointmentsLoaded;
            } else if (state is PacientDetailWithPreDiagnosisSuccess) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Paciente com pré diagnóstico'),
                      content: Text(
                          "O paciente já possui pré-diagnóstico para o dia ${state.preDiagnosisDate}"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Fechar"))
                      ],
                    );
                  });
            } else if (state is PacientDetailLoadEventSuccess) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Paciente Encontrado"),
                    content: Text(
                        "O Paciente foi encontrado. Clique abaixo para inserir o Pré-Diagnóstico"),
                    actions: <Widget>[
                      // define os botões na base do dialogo
                      TextButton(
                        child: Text("Fechar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Inserir Pré-Diagnóstico"),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            preDiagnosisRoute,
                            arguments: CreatePreDiagnosisArguments(
                                pacientModel: state.pacientDetailLoaded,
                                appointmentEventDate:
                                    this._appointmentModel.appointmentDate),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is PacientDetailLoadEventFail) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Paciente não encontrado"),
                    content: Text(
                        "O paciente não foi encontrado, é necessaria a inclusão do paciente no banco de dados para continuar.\nClique abaixo para cadastrar o paciente."),
                    actions: <Widget>[
                      // define os botões na base do dialogo
                      TextButton(
                        child: Text("Fechar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Cadastrar Paciente"),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            createPacientRoute,
                            arguments: preDiagnosisRoute,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: BlocBuilder<PacientBloc, PacientState>(
            cubit: this._pacientBloc,
            builder: (context, state) {
              return FutureBuilder(
                future: _loadAppointments(),
                builder: (context, snapshot) {
                  return SafeArea(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: (_appointmentList != null)
                                  ? ListView.builder(
                                      itemCount: _appointmentList.length,
                                      itemBuilder: (context, index) =>
                                          _listAppointmentView(
                                        _appointmentList[index],
                                      ),
                                    )
                                  : LayoutUtils.buildCircularProgressIndicator(
                                      context),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future _loadAppointments() async {
    _pacientBloc.add(AppointmentsLoad());
  }

  Future _loadPacientDetail(AppointmentModel appointment) async {
    _pacientBloc.add(PacientDetailLoad(appointment));
    this._appointmentModel = appointment;
  }

  Widget _listAppointmentView(AppointmentModel appointment) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _loadPacientDetail(appointment);
              },
              child: AppointmentTile(
                appointmentModel: appointment,
                userUid: this.userUid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
