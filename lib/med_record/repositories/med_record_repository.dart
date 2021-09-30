import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/main.dart';
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

  Future<CompleteDiagnosisModel> createPacientDiagnosis({
    @required CompleteDiagnosisModel completeDiagnosisModel,
    @required String date,
  }) async {
    try {
      var diagnosisList = await getCompleteDiagnosis(date: date);
      var diagnosis = completeDiagnosisModel.toMap();
      diagnosis['id'] = diagnosisList.length + 1;
      diagnosisList.add(diagnosis);
      await _medRecordCollectionReference.doc(_pacientHash).set({
        date: {'fulldiagnosis': diagnosisList},
      }, SetOptions(merge: true));

      completeDiagnosisModel.setId = diagnosis['id'];
      return completeDiagnosisModel;
    } on Exception catch (e, stack_trace) {
      await FirebaseCrashlytics.instance.recordError(e, stack_trace);
      return null;
    }
  }

  Future<Map> getExameByDiagnosisIdAndDate(
      DateTime diagnosisDate, int diagnosisId) async {
    var exams = [];
    var dateAsString = dateFormatter.format(diagnosisDate);
    var examDiagnosis;
    var user = Injector.appInstance.get<UserModel>();
    var snapshot = await FirebaseFirestore.instance
        .collection("exams")
        .doc(user.uid)
        .get();
    if (snapshot.data() != null && snapshot.data().containsKey('exams')) {
      exams = snapshot.data()["exams"];
    }

    exams.forEach((exam) {
      if (exam.containsKey("diagnosisDate") &&
          exam.containsKey("diagnosisId") &&
          exam["diagnosisDate"] == dateAsString &&
          exam["diagnosisId"] == diagnosisId.toString() &&
          exam["pacientHash"] == _pacientHash) {
        examDiagnosis = exam;
      }
    });

    return examDiagnosis;
  }

  Future<CompleteDiagnosisModel> updatePacientDiagnosis({
    @required CompleteDiagnosisModel completeDiagnosisModel,
    @required String date,
  }) async {
    var diagnosisList = await getCompleteDiagnosis(date: date);
    var updatedDiagnosisList = diagnosisList.map((diagnosis) {
      if (diagnosis['id'] == completeDiagnosisModel.id) {
        completeDiagnosisModel.createdAt =
            DateTime.fromMillisecondsSinceEpoch(diagnosis["createdAt"]);
        return completeDiagnosisModel.toMap();
      }

      return diagnosis;
    }).toList();

    await _medRecordCollectionReference.doc(_pacientHash).set({
      date: {'fulldiagnosis': updatedDiagnosisList},
    }, SetOptions(merge: true));

    return completeDiagnosisModel;
  }

  Future createOrUpdatePacientPreDiagnosis({
    @required PreDiagnosisModel preDiagnosisModel,
    @required String date,
  }) async {
    try {
      await _medRecordCollectionReference.doc(_pacientHash).set({
        date: {
          'prediagnosis': preDiagnosisModel.toMap(),
        }
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

  Future setOverviewByHash(String pacientHash, String resumo) async {
    try {
      var document = _medRecordCollectionReference.doc(pacientHash);

      await document.set(
        {
          'medRecordOverview': resumo,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Future<String> getOverviewByHash(String pacientHash) async {
    try {
      var document = _medRecordCollectionReference.doc(pacientHash);

      String overview = '';

      await document.get().then((snapshot) {
        if (snapshot.data() != null &&
            snapshot.data().containsKey('medRecordOverview')) {
          overview = snapshot.data()['medRecordOverview'];
        }
      });
      return overview;
    } catch (e) {
      e.toString();
      return 'erro do BD';
    }
  }

  Future<MedRecordModel> getMedRecordByHash(String pacientHash) async {
    try {
      MedRecordModel medRecord;
      var document = _medRecordCollectionReference.doc(pacientHash);

      bool boolMedRecordCreated;

      await document.get().then(
        (value) {
          var response = value.data();
          if (response != null) {
            boolMedRecordCreated = true;
            medRecord = MedRecordModel.fromMap(response);
          } else {
            boolMedRecordCreated = false;
          }
        },
      );

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
      return null;
    }
  }

  Future<List> getCompleteDiagnosis({@required String date}) async {
    var diagnosisList = [];
    await _medRecordCollectionReference
        .doc(_pacientHash)
        .get()
        .then((snapshot) {
      var data = snapshot.data()[date];
      if (data != null && data.containsKey('fulldiagnosis')) {
        var fullDiagnosis = data['fulldiagnosis'];
        diagnosisList = fullDiagnosis;
      }
    });

    return diagnosisList;
  }

  Future getmedRecordList() async {}
}
