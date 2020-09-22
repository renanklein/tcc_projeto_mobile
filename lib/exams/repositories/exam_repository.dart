import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';

class ExamRepository {
  final _firestore = Firestore.instance;

  //TODO: Alterar esse método depois !!!!!!!!!!!!!!!!!!!!!!
  Future saveExam(CardExamInfo cardExamInfo, ExamDetails examDetails,
      String filePath) async {
    var user = await _getUser();
    List exams = [];

    var snapshot =
        await this._firestore.collection("exams").document(user.uid).get();

    if (snapshot.data != null && snapshot.data.containsKey("exams")) {
      exams = snapshot.data["exams"];
    }

    exams.add({
      "filePath": filePath,
      "examDate": cardExamInfo.getExamDate,
      "examType": cardExamInfo.getExamType,
      "pacientName": examDetails.getPacientName,
      "examinationUnit": examDetails.getExaminationUnit,
      "requestingDoctor": examDetails.getRequestingDoctor,
      "examResponsible": examDetails.getExamResponsable,
      "examDescription": examDetails.getExamDescription,
      "diagnosticHypothesis": examDetails.getDiagnosticHypothesis,
      "otherPacientInformation": examDetails.getOtherPacientInformation
    });

    await this
        ._firestore
        .collection("exams")
        .document(user.uid)
        .setData({"exams": exams});
  }

  //TODO: Alterar esse método depois !!!!!!!!!!!!!!!!!!!!!!
  Future<List> getExam() async {
    var user = await _getUser();

    List exams;
    List displayableExams = [];

    var examSnapshot =
        await this._firestore.collection("exams").document(user.uid).get();

    if (examSnapshot.data.containsKey("exams")) {
      exams = examSnapshot.data["exams"];
    }
    exams.forEach((exam) {
      displayableExams.add(
          CardExamInfo(examDate: exam["examDate"], examType: exam["examType"]));
      displayableExams.add(ExamDetails(
          pacientName: exam["pacientName"],
          examinationUnit: exam["examinationUnit"],
          requestingDoctor: exam["requestingDoctor"],
          examResponsable: exam["examResponsible"],
          examDate: exam["examDate"],
          examDescription: exam["examDescription"],
          diagnosticHypothesis: exam["diagnosticHypothesis"],
          otherPacientInformation: exam["otherPacientInformation"]));

      displayableExams.add(exam["filePath"]);
    });

    return displayableExams;
  }

  Future<FirebaseUser> _getUser() async {
    return await FirebaseAuth.instance.currentUser();
  }
}
