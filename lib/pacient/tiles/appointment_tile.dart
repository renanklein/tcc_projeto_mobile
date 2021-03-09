import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentTile extends StatelessWidget {
  final String nome;
  final String telefone;
  final DateTime dataAgendamento;
  final String horarioAgendamento;

  var dateFormat = DateFormat("dd/MM/yyyy");

  AppointmentTile(
      {this.nome,
      this.telefone,
      this.dataAgendamento,
      this.horarioAgendamento});

  @override
  Widget build(BuildContext context) {
    var dateTimeAgendamento =
        "${dateFormat.format(this.dataAgendamento)}  ${this.horarioAgendamento}";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: Color(0xFF84FFFF),
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
            nome,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          Text(
            telefone,
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
