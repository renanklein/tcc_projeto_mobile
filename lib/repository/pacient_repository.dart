import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/model/pacient_model.dart';

class PacientRepository {
  final CollectionReference _pacientsCollectionReference =
      Firestore.instance.collection('pacients');

  String _userId;
  set userId(String uid) => this._userId = uid;

  Future createPacient({
    @required String userId,
    @required String nome,
    @required String email,
    @required String telefone,
    @required String identidade,
    @required String cpf,
    @required String dtNascimento,
    @required String sexo,
  }) async {
    try {
      await _pacientsCollectionReference.add(PacientModel(
              userId: userId,
              nome: nome,
              email: email,
              telefone: telefone,
              identidade: identidade,
              cpf: cpf,
              dtNascimento: dtNascimento,
              sexo: sexo)
          .toMap());
    } catch (e) {
      return e.toString();
    }
  }

  Future getPacientByName(String name) async {}

  Future getPacients() async {}
}
