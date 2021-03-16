import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';

import '../../utils/layout_utils.dart';
import '../blocs/pacient_bloc.dart';
import '../models/appointment_model.dart';
import '../repositories/pacient_repository.dart';

class AppointmentTile extends StatefulWidget {
  final AppointmentModel appointmentModel;
  final String userUid;

  AppointmentTile({@required this.appointmentModel, @required this.userUid});

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  AppointmentModel get appointmentModel => this.widget.appointmentModel;
  String get userUid => this.widget.userUid;
  PacientBloc _pacientBloc;

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

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: color,
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
              this.color = Colors.yellow;
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
                  Text(
                    dateTimeAgendamento,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  Text(
                    this.appointmentModel.nome,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  Text(
                    this.appointmentModel.telefone,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
