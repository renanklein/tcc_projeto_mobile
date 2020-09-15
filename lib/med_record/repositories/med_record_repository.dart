import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';

class MedRecordRepository {
  final CollectionReference _medRecordCollectionReference =
      Firestore.instance.collection('prontuario');
  String _pacientHash;
  set pacientHash(String hash) => this._pacientHash = hash;

  Future updateMedRecord({
    @required String pacientHash,
    @required MedRecordModel medRecordModel,
  }) async {
    try {
      await _medRecordCollectionReference
          .document(pacientHash)
          .setData(medRecordModel.toMap());
    } catch (e) {
      return e.toString();
    }
  }

  Future getMedRecordByCpf() async {
    try {
      MedRecordModel medRecord;
      var document = _medRecordCollectionReference.document(_pacientHash);

      if (document != null) {
        await document.get().then(
              (value) => medRecord = MedRecordModel.fromMap(value.data),
            );
        await document.setData({'empty': 'yes'});
      } else {
        await document.setData({'empty': 'yes'});
      }
      return medRecord;
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future getmedRecordList() async {}
}
