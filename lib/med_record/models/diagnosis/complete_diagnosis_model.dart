import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/prescription_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';

class CompleteDiagnosisModel {
  ProblemModel _problemModel;
  DiagnosisModel _diagnosisModel;
  PrescriptionModel _prescriptionModel;
  DateTime _date;

  CompleteDiagnosisModel({
    @required ProblemModel problem,
    @required DiagnosisModel diagnosis,
    @required DateTime date,
    PrescriptionModel prescription,
  }) {
    this._problemModel = problem;
    this._diagnosisModel = diagnosis;
    this._prescriptionModel = prescription;
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    return {
      'problem': _problemModel.toMap(),
      'diagnosis': _diagnosisModel.toMap(),
      'prescription': _prescriptionModel.toMap(),
      'date': _date.toString(),
    };
  }

  static CompleteDiagnosisModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CompleteDiagnosisModel(
      problem: map['problem'],
      diagnosis: map['diagnosis'],
      prescription: map['prescription'],
      date: map['date'],
    );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
