import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';

class MedRecordRepository {
  final CollectionReference _medRecordCollectionReference =
      Firestore.instance.collection('prontuario');

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

  Future<MedRecordModel> getMedRecordByCpf(String pacientHash) async {
    try {
      MedRecordModel medRecord;
      var document = _medRecordCollectionReference.document(pacientHash);
      medRecord.setPacientHash = pacientHash;

      if (document != null) {
        await document.get().then(
              (value) => medRecord = MedRecordModel.fromMap(value.data),
            );
        //await document.setData({'created': 'yes'});
      } else {
        await document.setData({'created': DateTime.now().toString()});
      }
      return medRecord;
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future getmedRecordList() async {}
}
