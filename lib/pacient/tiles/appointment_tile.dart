import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/pacient/route_appointment_arguments.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';

import '../blocs/pacient_bloc.dart';
import '../models/appointment_model.dart';

class AppointmentTile extends StatelessWidget {
  final AppointmentModel appointmentModel;
  final String userUid;
  final Function loadAppointments;

  AppointmentTile(
      {@required this.appointmentModel,
      @required this.userUid,
      @required this.loadAppointments});



  Widget build(BuildContext context) {
    var pacientBloc = BlocProvider.of<PacientBloc>(context);
    var color = this.appointmentModel.pacientModel != null && this.appointmentModel.hasPreDiagnosis ? 
       Colors.yellow : Color(0xFF84FFFF);
    var dateFormatter = DateFormat("dd/MM/yyyy");
    var dateTimeAgendamento =
        "${dateFormatter.format(this.appointmentModel.appointmentDate)}  ${this.appointmentModel.appointmentTime}";

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: color,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: GestureDetector(
                  onTap: () {
                    if (DateTime.now()
                            .isBefore(appointmentModel.appointmentDate) &&
                        this.appointmentModel.pacientModel != null && !this.appointmentModel.hasPreDiagnosis) {
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
                                      Navigator.pushReplacementNamed(
                                        context,
                                        preDiagnosisRoute,
                                        arguments: RouteAppointmentArguments(
                                            pacientModel:
                                                this.appointmentModel.pacientModel,
                                            appointmentModel:
                                                this.appointmentModel),
                                      ).then((value) => pacientBloc.add(
                                          AppointmentsLoad()));
                                    },
                                    child: Text("Sim"))
                              ],
                            );
                          });
                    } else if ( this.appointmentModel.pacientModel != null && this.appointmentModel.hasPreDiagnosis) {
                      var dateAsString = dateFormatter.format(this.appointmentModel.appointmentDate);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Paciente com pré diagnóstico'),
                              content: Text(
                                  "O paciente já possui pré-diagnóstico para o dia $dateAsString"),
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
                                          index: '3',
                                          pacientModel: this.appointmentModel.pacientModel),
                                    );
                                  },
                                ),
                              ],
                            );
                          });
                    } else if (this.appointmentModel.pacientModel != null && !this.appointmentModel.hasPreDiagnosis) {
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
                                        pacientModel: this.appointmentModel.pacientModel,
                                        appointmentModel:
                                            this.appointmentModel),
                                  ).then((value) => pacientBloc.add(
                                     AppointmentsLoad()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (this.appointmentModel.pacientModel == null) {
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
                                    createOrEditPacient,
                                    arguments: RouteAppointmentArguments(
                                        routePath: preDiagnosisRoute,
                                        appointmentModel:
                                            this.appointmentModel),
                                  ).then((value) => pacientBloc.add(
                                     AppointmentsLoad()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Column(
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
                  ),
                ));
  }
}

