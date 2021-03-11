import 'package:flutter/material.dart';

class AppointmentModel {
  String _nome;
  String _email;
  String _telefone;
  DateTime _dataAgendamento;
  String _horarioAgendamento;
  bool _hasPreDiagnosis;

  AppointmentModel({
    @required String nome,
    @required String telefone,
    @required DateTime appointmentDate,
    @required String appointmentTime,
    bool hasPreDiagnosis,
    String email,
  }) {
    this._nome = nome.toUpperCase();
    this._email = email;
    this._telefone = telefone;
    this._dataAgendamento = appointmentDate;
    this._horarioAgendamento = appointmentTime;
    this._hasPreDiagnosis = hasPreDiagnosis;
  }

  static AppointmentModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppointmentModel(
        nome: map['description'],
        telefone: map['phone'],
        appointmentDate: DateTime(
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
        appointmentTime: "${map['begin'] - map['end']}");
  }

  String get email => this._email;
  String get nome => this._nome;
  String get telefone => this._telefone;
  DateTime get appointmentDate => this._dataAgendamento;
  String get appointmentTime => this._horarioAgendamento;
  bool get hasPreDiagnosis => this._hasPreDiagnosis;

  set hasPreDiagnosis(bool hasPreDiagnosis) =>
      this._hasPreDiagnosis = hasPreDiagnosis;
}
