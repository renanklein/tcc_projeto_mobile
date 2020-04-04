import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_projeto_app/model/pacient_model.dart';

class PacientRepository {
  final CollectionReference _pacientsCollectionReference =
      Firestore.instance.collection('pacients');

  String _userId;
  set userId(String uid) => this._userId = uid;

  Future createPacient({
    @required PacientModel pacient,
  }) async {
    try {
      await _pacientsCollectionReference.add(
        pacient.toMap(),
      );
    } catch (e) {
      return e.toString();
    }
  }

  Future getPacientByName(String name) async {}

  Future getPacientsList() async {
    try {
      var pacientDocuments = await _pacientsCollectionReference.getDocuments();
      if (pacientDocuments.documents.isNotEmpty) {
        return pacientDocuments.documents
            .map((snapshot) => PacientModel.fromMap(snapshot.data))
            .where((mappedItem) => mappedItem.nome != null)
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }
}
