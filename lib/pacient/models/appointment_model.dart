import 'package:flutter/material.dart';

class AppointmentModel {
  String _nome;
  String _email;
  String _telefone;
  DateTime _horarioAgendamento;

  AppointmentModel({
    @required String nome,
    @required String telefone,
    @required DateTime appointmentTime,
    String email,
  }) {
    this._nome = nome;
    this._email = email;
    this._telefone = telefone;
    this._horarioAgendamento = appointmentTime;
  }

  static AppointmentModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppointmentModel(
      nome: map['description'],
      telefone: map['phone'],
      appointmentTime: DateTime(
        int.parse(
          map.keys.elementAt(0).split("-")[0],
        ),
        int.parse(
          map.keys.elementAt(0).split("-")[1],
        ),
        int.parse(
          map.keys.elementAt(0).split("-")[2],
        ),
      ),
    );
  }

  String get email => this._email;
  String get nome => this._nome;
  String get telefone => this._telefone;
  DateTime get appointmentTime => this._horarioAgendamento;
}
