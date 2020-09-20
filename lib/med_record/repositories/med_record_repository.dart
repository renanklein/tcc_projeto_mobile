import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';

class MedRecordRepository {
  final CollectionReference _medRecordCollectionReference =
      FirebaseFirestore.instance.collection('prontuario');

  Future updateMedRecord({
    @required String pacientHash,
    @required MedRecordModel medRecordModel,
  }) async {
    try {
      await _medRecordCollectionReference
          .doc(pacientHash)
          .set(medRecordModel.toMap());
    } catch (e) {
      return e.toString();
    }
  }

  Future<MedRecordModel> getMedRecordByCpf(String pacientHash) async {
    try {
      MedRecordModel medRecord;
      var document = _medRecordCollectionReference.doc(pacientHash);
      medRecord = new MedRecordModel(pacientHash: pacientHash, overview: null);

      await document.get().then(
            (value) => medRecord = MedRecordModel.fromMap(value.data()),
          );

      await document.set({
        'Diagnóstico': {
          'problema': {'descrição': 'teste', 'id': '08'},
          'diagnostico': {'descrição': 'teste', 'cid': '8459'},
          'prescrição': {'droga': 'teste', 'dose': '8459', 'uso': 'oral'},
        }
      });

      return medRecord;
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future getmedRecordList() async {}
}
