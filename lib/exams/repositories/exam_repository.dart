import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';

class ExamRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> _uploadExam(File encriptedFile, String fileName) async {
    var storageRef = this._storage.ref().child(fileName);

    var putFileResult = await storageRef.putFile(encriptedFile).onComplete;

    return await putFileResult.ref.getDownloadURL();
  }

  Future saveExam(CardExamInfo cardExamInfo, ExamDetails examDetails,
      File encriptedFile, String fileName) async {
    var user = _getUser();
    var fileDownloadURL = await this._uploadExam(encriptedFile, fileName);
    List exams = [];

    var snapshot =
        await this._firestore.collection("exams").doc(user.uid).get();

    if (snapshot.data != null && snapshot.exists) {
      exams = snapshot.data()["exams"];
    }

    exams.add({
      "fileDownloadURL": fileDownloadURL,
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
        .doc(user.uid)
        .set({"exams": exams});
  }

  Future<List> getExam() async {
    var user = _getUser();

    List exams;
    List displayableExams = [];

    var examSnapshot =
        await this._firestore.collection("exams").doc(user.uid).get();

    if (examSnapshot.exists) {
      exams = examSnapshot.data()["exams"];
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

      displayableExams.add(exam["fileDownloadURL"]);
    });

    return displayableExams;
  }

  User _getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
