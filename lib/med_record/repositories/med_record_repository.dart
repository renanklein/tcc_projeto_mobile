import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:intl/intl.dart';

class MedRecordRepository {
  final CollectionReference _medRecordCollectionReference =
      FirebaseFirestore.instance.collection('medRecord');
  String _pacientHash;

  set setPacientHash(String hash) => this._pacientHash = hash;

  List<MedRecordModel> _medRecordList;
  List<MedRecordModel> get getMedRecordList => _medRecordList;

  var date = DateTime.now();
  var dateFormat = DateFormat("dd/MM/yyyy");

  Future createPacientDiagnosis({
    @required CompleteDiagnosisModel completeDiagnosisModel,
    @required String date,
  }) async {
    try {
      await _medRecordCollectionReference.doc(_pacientHash).set({
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

  Future<MedRecordModel> getMedRecordByHash(String pacientHash) async {
    try {
      MedRecordModel medRecord;
      var document = _medRecordCollectionReference.doc(pacientHash);
      medRecord = new MedRecordModel(pacientHash: pacientHash, overview: null);

      bool boolMedRecord;
      await document.get().then((value) {
        if (value.data() != null) {
          medRecord = MedRecordModel.fromMap(value.data());
          boolMedRecord = true;
        } else {
          boolMedRecord = false;
        }
      });

      if (boolMedRecord == false) {
        String dt = dateFormat.format(date);
        await document.set({
          'created': dt,
        }, SetOptions(merge: true));
      }

      this._pacientHash = pacientHash;

      return medRecord;
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future getmedRecordList() async {}
}
