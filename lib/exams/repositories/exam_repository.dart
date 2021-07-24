import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/main.dart';

class ExamRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> _uploadExam(File encriptedFile, String fileName) async {
    var storageRef = this._storage.ref().child(fileName);

    var putFileResult = await storageRef.putFile(encriptedFile);

    return await putFileResult.ref.getDownloadURL();
  }

  Future uploadCryptoKey() async {
    var aesKey = Key.fromSecureRandom(16);

    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;

    var credentialsFile = File("$tempPath/credentials.txt");

    await credentialsFile.writeAsString(aesKey.base64);

    var storageRef = this._storage.ref().child('credentials.txt');

    await storageRef.putFile(credentialsFile);
  }

  Future<String> getCryptoKeyDownload() async {
    var storageRef = this._storage.ref().child('credentials.txt');

    return await storageRef.getDownloadURL();
  }

  Future<dynamic> getExamModels() async {
    var data = Map();
    await this
        ._firestore
        .collection("modelExam")
        .doc(_getUser().uid)
        .get()
        .then((res) => data = res.data());

    return data;
  }

  Future updateExamModels(String examModelType, List examModelFields,
      String oldExamModelType) async {
    Map models = await getExamModels();
    List modelMaps = models['models'];

    modelMaps.forEach((map) {
      if (map["Tipo de Exame"] == oldExamModelType) {
        map["Tipo de Exame"] = examModelType;
        map["fields"] = examModelFields;
      }
    });

    await this
        ._firestore
        .collection("modelExam")
        .doc(_getUser().uid)
        .set(models);
  }

  Future<List<ExamSolicitationModel>> getExamSolictations(String pacientHash) async {
    try{
      var examSolicitations = <ExamSolicitationModel>[];
      var querySnapshot = await this._firestore.collection("examSolicitation")
      .doc(_getUser().uid)
      .collection(pacientHash)
      .get();

      querySnapshot.docs.map((snapshot) {
        var data = snapshot.data();
        if(data != null && data.isNotEmpty){
          examSolicitations.add(ExamSolicitationModel.fromMap(data, snapshot.id));
        }
      });

      return examSolicitations;

    }catch(error, stackTrace){
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      throw error;
    }
  }

  Future saveExamSolicitation(
      String examModelType, String solicitationDate, String pacientHash) async {
    await this
        ._firestore
        .collection("examSolicitation")
        .doc(_getUser().uid)
        .collection(pacientHash)
        .doc()
        .set({
      "status" : "solicitado",
      "examModelType": examModelType,
      "solicationDate": solicitationDate
    });
  }

  Future saveModelExam(Map modelExam, String examType) async {
    var models = await getExamModels();
    if (models == null) {
      models = {
        "models": <Map>[modelExam]
      };
    } else {
      models["models"].add(modelExam);
    }

    await this
        ._firestore
        .collection("modelExam")
        .doc(_getUser().uid)
        .set(models);
  }

  Future deleteExamModels(List<Map> examModels) async {
    var response = await getExamModels();

    var models = response['models'] as List;
    var comparator = DeepCollectionEquality.unordered();

    for (int i = 0; i < examModels.length; i++) {
      Map elementToBeRemoved = Map();
      models.forEach((map) {
        if (comparator.equals(map, examModels.elementAt(i))) {
          elementToBeRemoved = map;
        }
      });

      models.remove(elementToBeRemoved);
    }

    await this
        ._firestore
        .collection("modelExam")
        .doc(_getUser().uid)
        .set(response);
  }

  Future saveExam(CardExamInfo cardExamInfo, ExamDetails examDetails,
      File encriptedFile, String fileName, String pacientHash, IV iv,
      {DateTime diagnosisDate, String diagnosisId}) async {
    var user = _getUser();
    var fileDownloadURL = encriptedFile == null
        ? ""
        : await this._uploadExam(encriptedFile, fileName);

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
      "dynamicFields": examDetails.toMap(),
      "pacientHash": pacientHash,
      "IV": iv.base64,
      "diagnosisDate":
          diagnosisDate == null ? null : dateFormatter.format(diagnosisDate),
      "diagnosisId": diagnosisId
    });

    await this
        ._firestore
        .collection("exams")
        .doc(user.uid)
        .set({"exams": exams});
  }

  Future<List> getExam(String pacientHash) async {
    var user = _getUser();

    List exams = [];
    List displayableExams = [];

    var dbSnapshot =
        await this._firestore.collection("exams").doc(user.uid).get();

    if (dbSnapshot.exists) {
      var examsSnapshot = dbSnapshot.data()["exams"];
      pacientHash == null
          ? exams = examsSnapshot
          : _addPacientsExams(exams, examsSnapshot, pacientHash);
    }
    exams.forEach((exam) {
      displayableExams.add(
          CardExamInfo(examDate: exam["examDate"], examType: exam["examType"]));

      displayableExams.add(ExamDetails.fromMap(exam["dynamicFields"]));

      displayableExams.add(exam["fileDownloadURL"]);

      displayableExams.add(exam['IV']);
    });

    return displayableExams;
  }

  User _getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  void _addPacientsExams(List exams, List examsSnapshot, String pacientHash) {
    examsSnapshot.forEach((el) {
      if (el["pacientHash"] == pacientHash) {
        exams.add(el);
      }
    });
  }
}
