import 'package:flutter/material.dart';

class PacientModel {
  String _nome;
  String _email;
  String _telefone;
  String _identidade;
  String _cpf;
  String _dtNascimento;
  String _sexo;
  String _vinculo = 'paciente';
  String _userId;
  String _salt;

  PacientModel({
    @required String nome,
    @required String email,
    @required String telefone,
    @required String identidade,
    @required String cpf,
    @required String dtNascimento,
    @required String sexo,
    @required String userId,
    @required String salt,
  }) {
    this._nome = nome;
    this._email = email;
    this._telefone = telefone;
    this._identidade = identidade;
    this._cpf = cpf;
    this._dtNascimento = dtNascimento;
    this._sexo = sexo;
    this._userId = userId;
    this._salt = salt;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': _userId,
      'nome': _nome,
      'email': _email,
      'telefone': _telefone,
      'identidade': _identidade,
      'cpf': _cpf,
      'dtNascimento': _dtNascimento,
      'sexo': _sexo,
      'vinculo': _vinculo,
      'salt': _salt,
    };
  }

  static PacientModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PacientModel(
      userId: map['userId'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      identidade: map['identidade'],
      cpf: map['cpf'],
      dtNascimento: map['dtNascimento'],
      sexo: map['sexo'],
      salt: map['salt'],
    );
  }

  String get email => this._email;
  String get nome => this._nome;
  String get userUid => this._userId;
  //set userUid(String uid) => this._userId = uid;

}
