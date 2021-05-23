import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/pacient/route_appointment_arguments.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';

import '../../utils/layout_utils.dart';
import '../blocs/pacient_bloc.dart';
import '../models/appointment_model.dart';
import '../repositories/pacient_repository.dart';

class AppointmentTile extends StatefulWidget {
  final AppointmentModel appointmentModel;
  final String userUid;
  final Function loadAppointments;
  bool hasPreDiagnosis = false;

  AppointmentTile(
      {@required this.appointmentModel,
      @required this.userUid,
      @required this.loadAppointments});

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  AppointmentModel get appointmentModel => this.widget.appointmentModel;
  String get userUid => this.widget.userUid;
  PacientState get getPacientCurrentState => this._pacientBloc.state;
  PacientBloc _pacientBloc;
  Function get refreshAppointments => this.widget.loadAppointments;

  Color color = Color(0xFF84FFFF);
  var dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    var pacientRepository = Injector.appInstance.get<PacientRepository>();
    pacientRepository.userId = this.userUid;
    this._pacientBloc = new PacientBloc(pacientRepository: pacientRepository);

    this._pacientBloc.add(PacientDetailLoad(this.appointmentModel));
    super.initState();
  }

  @override
  void dispose() {
    this._pacientBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dateTimeAgendamento =
        "${dateFormat.format(this.appointmentModel.appointmentDate)}  ${this.appointmentModel.appointmentTime}";

    return GestureDetector(
      onTap: () {
        if (DateTime.now().isBefore(appointmentModel.appointmentDate) &&
            this._pacientBloc.state is PacientDetailLoadEventSuccess) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Agendamento no futuro'),
                  content: Text(
                      "Esse atendimento não é para hoje. Deseja prosseguir ?"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Não")),
                    TextButton(
                        onPressed: () {
                          var state = this._pacientBloc.state
                              as PacientDetailLoadEventSuccess;
                          Navigator.pushReplacementNamed(
                            context,
                            preDiagnosisRoute,
                            arguments: RouteAppointmentArguments(
                                pacientModel: state.pacientDetailLoaded,
                                appointmentModel: this.appointmentModel),
                          ).then((value) => this
                              ._pacientBloc
                              .add(PacientDetailLoad(this.appointmentModel)));
                        },
                        child: Text("Sim"))
                  ],
                );
              });
        } else if (this._pacientBloc.state
            is PacientDetailWithPreDiagnosisSuccess) {
          showDialog(
              context: context,
              builder: (context) {
                var state = this._pacientBloc.state
                    as PacientDetailWithPreDiagnosisSuccess;

                return AlertDialog(
                  title: Text('Paciente com pré diagnóstico'),
                  content: Text(
                      "O paciente já possui pré-diagnóstico para o dia ${state.preDiagnosisDate}"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Fechar")),
                    TextButton(
                      child: Text("Ir para o Prontuário"),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          medRecordRoute,
                          arguments: MedRecordArguments(
                              index: '3', pacientModel: state.pacientModel),
                        );
                      },
                    ),
                  ],
                );
              });
        } else if (this._pacientBloc.state is PacientDetailLoadEventSuccess) {
          var state = this._pacientBloc.state as PacientDetailLoadEventSuccess;
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
                        arguments: RouteAppointmentArguments(
                            pacientModel: state.pacientDetailLoaded,
                            appointmentModel: this.appointmentModel),
                      ).then((value) => this
                          ._pacientBloc
                          .add(PacientDetailLoad(this.appointmentModel)));
                    },
                  ),
                ],
              );
            },
          );
        } else if (this._pacientBloc.state is PacientDetailLoadEventFail) {
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
                        arguments: RouteAppointmentArguments(
                            routePath: preDiagnosisRoute,
                            appointmentModel: this.appointmentModel),
                      ).then((value) => this
                          ._pacientBloc
                          .add(PacientDetailLoad(this.appointmentModel)));
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: this.color,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
          child: BlocListener<PacientBloc, PacientState>(
            cubit: this._pacientBloc,
            listener: (context, state) {
              if (state is PacientDetailWithPreDiagnosisSuccess) {
                setState(() {
                  this.color = Colors.yellow;
                  this.widget.hasPreDiagnosis = true;
                });
              }
            },
            child: BlocBuilder<PacientBloc, PacientState>(
              cubit: this._pacientBloc,
              builder: (context, state) {
                if (state is PacientDetailLoading) {
                  return LayoutUtils.buildCircularProgressIndicator(context);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                      child: Text(
                        dateTimeAgendamento,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                      child: Text(
                        this.appointmentModel.nome,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                      child: Text(
                        "Tel.: " + this.appointmentModel.telefone,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }
}
