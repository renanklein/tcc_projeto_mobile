import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';

class AppointmentModel {
  String _nome;
  String _email;
  String _telefone;
  DateTime _dataAgendamento;
  String _horarioAgendamento;
  DateTime _changedDate;
  String _changedTime;
  PacientModel _pacientModel;
  bool _hasPreDiagnosis = false;

  AppointmentModel({
    @required String nome,
    @required String telefone,
    @required DateTime appointmentDate,
    @required String appointmentTime,
    String email,
    PacientModel pacientModel
  }) {
    this._nome = nome.toUpperCase();
    this._email = email;
    this._telefone = telefone;
    this._dataAgendamento = appointmentDate;
    this._horarioAgendamento = appointmentTime;
    this._pacientModel = pacientModel;
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
  PacientModel get pacientModel => this._pacientModel;
  bool get hasPreDiagnosis => this._hasPreDiagnosis;
  DateTime get changedDate => this._changedDate;
  String get changedTime => this._changedTime;
  set pacientModel(PacientModel pacient) => this._pacientModel = pacient;
  set hasPreDiagnosis(bool hasPreDiagnosis) => this._hasPreDiagnosis = true;
  set changedDate(DateTime changedDate) => this._changedDate = changedDate;
  set changedTime(String changedTime) => this._changedTime = changedTime;
  set appointmentDate(DateTime date) => this._dataAgendamento = date; 
  set appointmentTime(String time) => this._horarioAgendamento = time;
}
