import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';

class AppointmentTile extends StatelessWidget {
  final AppointmentModel appointmentModel;

  var dateFormat = DateFormat("dd/MM/yyyy");

  AppointmentTile({this.appointmentModel});

  @override
  Widget build(BuildContext context) {
    var dateTimeAgendamento =
        "${dateFormat.format(this.appointmentModel.appointmentDate)}  ${this.appointmentModel.appointmentTime}";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: this.appointmentModel.hasPreDiagnosis
            ? Colors.yellowAccent
            : Color(0xFF84FFFF),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
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
      ),
    );
  }
}
