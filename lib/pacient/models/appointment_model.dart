import 'package:flutter/material.dart';

class AppointmentModel {
  String _nome;
  String _email;
  String _telefone;

  AppointmentModel({
    @required String nome,
    @required String telefone,
    String email,
  }) {
    this._nome = nome;
    this._email = email;
    this._telefone = telefone;
  }

  static AppointmentModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppointmentModel(
      nome: map['description'],
      telefone: map['phone'],
    );
  }

  String get email => this._email;
  String get nome => this._nome;
  String get telefone => this._telefone;
}
