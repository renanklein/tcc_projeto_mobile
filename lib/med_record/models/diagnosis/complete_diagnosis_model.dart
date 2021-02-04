import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/prescription_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';

class CompleteDiagnosisModel {
  ProblemModel _problemModel;
  DiagnosisModel _diagnosisModel;
  PrescriptionModel _prescriptionModel;
  DateTime _diagnosisDate;

  CompleteDiagnosisModel({
    @required ProblemModel problem,
    @required DiagnosisModel diagnosis,
    PrescriptionModel prescription,
    DateTime date,
  }) {
    this._problemModel = problem;
    this._diagnosisModel = diagnosis;
    this._prescriptionModel = prescription;
    this._diagnosisDate = date;
  }

  Map<String, dynamic> toMap() {
    return {
      'problem': _problemModel.toMap(),
      'diagnosis': _diagnosisModel.toMap(),
      'prescription': _prescriptionModel.toMap(),
    };
  }

  static CompleteDiagnosisModel fromMap(Map<String, dynamic> map, String key) {
    if (map == null || map.length < 2) return null;

    int year = int.parse(key.split('/')[2]);
    int mon = int.parse(key.split('/')[1]);
    int day = int.parse(key.split('/')[0]);

    return CompleteDiagnosisModel(
      problem: ProblemModel.fromMap(map['problem']),
      diagnosis: DiagnosisModel.fromMap(map['diagnosis']),
      prescription: PrescriptionModel.fromMap(map['prescription']),
      date: new DateTime(
        year,
        mon,
        day,
      ),
    );
  }

  DateTime get getDate => this._diagnosisDate;
  set setDate(DateTime dt) => this._diagnosisDate = dt;

  //set userUid(String uid) => this._userId = uid;
}
