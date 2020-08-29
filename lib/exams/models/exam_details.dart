import 'package:flutter/material.dart';

class ExamDetails {
  final pacientName;
  final examinationUnit;
  final requestingDoctor;
  final examResponsable;
  final examDate;
  final examDescription;
  final diagnosticHypothesis;
  final otherPacientInformation;

  ExamDetails(
      {@required this.pacientName,
      @required this.examinationUnit,
      @required this.requestingDoctor,
      @required this.examResponsable,
      @required this.examDate,
      @required this.examDescription,
      @required this.diagnosticHypothesis,
      @required this.otherPacientInformation});

  String get getPacientName => this.pacientName;
  String get getExaminationUnit => this.examinationUnit;
  String get getRequestingDoctor => this.requestingDoctor;
  String get getExamResponsable => this.examResponsable;
  String get getExamDate => this.examDate;
  String get getExamDescription => this.examDescription;
  String get getDiagnosticHypothesis => this.diagnosticHypothesis;
  String get getOtherPacientInformation => this.otherPacientInformation;
}
