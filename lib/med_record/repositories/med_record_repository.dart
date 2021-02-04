import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';

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
      }, SetOptions(merge: true));
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future createPacientPreDiagnosis({
    @required PreDiagnosisModel preDiagnosisModel,
  }) async {
    try {
      await _medRecordCollectionReference.doc(_pacientHash).set({
        preDiagnosisModel.getPreDiagnosisDate: preDiagnosisModel.toMap(),
      }, SetOptions(merge: true));
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
          .set(medRecordModel.toMap(), SetOptions(merge: true));
    } catch (e) {
      return e.toString();
    }
  }

  Future<MedRecordModel> getMedRecordByHash(String pacientHash) async {
    try {
      //TODO: Pegar o Prontuario Médico

      MedRecordModel medRecord;
      var document = _medRecordCollectionReference.doc(pacientHash);

      bool boolMedRecordCreated;

      await document.get().then((value) {
        if (value.data()['created'] != null) {
          boolMedRecordCreated = true;
          medRecord = MedRecordModel.fromMap(value.data());
        } else {
          boolMedRecordCreated = false;
        }
      });

      if (boolMedRecordCreated == false) {
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
