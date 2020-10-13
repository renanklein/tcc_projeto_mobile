import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:intl/intl.dart';

class MedRecordRepository {
  final CollectionReference _medRecordCollectionReference =
      Firestore.instance.collection('medRecord');
  String _pacientHash;

  set setPacientHash(String hash) => this._pacientHash = hash;

  var date = DateTime.now();
  var dateFormat = DateFormat("dd/MM/yyyy");

  Future createPacientDiagnosis({
    @required CompleteDiagnosisModel completeDiagnosisModel,
    @required String date,
  }) async {
    try {
      await _medRecordCollectionReference.document(_pacientHash).setData({
        date: completeDiagnosisModel.toMap(),
      });
    } on Exception catch (e) {
      return e.toString();
    }
  }

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

//TODO: getCreatedDate

      String dt = dateFormat.format(date);
      await document.setData({
        'created': dt,
      });

      this._pacientHash = pacientHash;

      return medRecord;
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future getmedRecordList() async {}
}
