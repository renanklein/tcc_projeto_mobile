import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';

class PacientRepository extends ChangeNotifier {
  final CollectionReference _pacientsCollectionReference =
      FirebaseFirestore.instance.collection('pacients');

  final CollectionReference _agendaCollectionReference =
      FirebaseFirestore.instance.collection('agenda');

  String _userId;

  List<PacientModel> _pacients;
  List<PacientModel> get pacientsList => _pacients;

  //String _userId;
  set userId(String uid) => this._userId = uid;

  final StreamController<List<PacientModel>> _pacientsController =
      StreamController<List<PacientModel>>.broadcast();

  Future createPacient({
    @required PacientModel pacient,
  }) async {
    try {
      await _pacientsCollectionReference.add(
        pacient.toMap(),
      );
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
  }

  Future<PacientModel> getPacientByNameAndPhone(
      AppointmentModel appointmentModel) async {
    PacientModel pacientModel;
    try {
      var doc = await _pacientsCollectionReference
          .where("nome", isEqualTo: appointmentModel.nome)
          .where("telefone", isEqualTo: appointmentModel.telefone)
          .get();
      if (doc.docs.isNotEmpty) {
        var pacientsList = doc.docs
            .map((snapshot) => PacientModel.fromMap(snapshot.data()))
            .where((mappedItem) =>
                mappedItem.getNome != null && mappedItem.medicId == _userId)
            .toList();
        pacientModel = pacientsList[0];
      }

      return pacientModel;
    } on Exception catch (e) {
      e.toString();
      return null;
    }
  }

  Future<List<AppointmentModel>> getAppointments() async {
    List<AppointmentModel> _appointmentsList = <AppointmentModel>[];
    await _agendaCollectionReference
        .doc(this._userId)
        .collection("events")
        .get()
        .then(
          (resp) => resp.docs.forEach(
            (snapshot) {
              var events = snapshot.data().values.first;
              var snapId = snapshot.id;
              var _appointmentDate = DateTime(
                  int.parse(snapId.split("-")[0]),
                  int.parse(snapId.split("-")[1]),
                  int.parse(snapId.split("-")[2]));

              events.forEach(
                (event) {
                  if (event["status"] != "canceled" &&
                      _appointmentDate.compareTo(new DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          )) >=
                          0) {
                    var beginTime = event['begin'];
                    var endTime = event['end'];
                    var eventTime = "$beginTime - $endTime";

                    _appointmentsList.add(
                      AppointmentModel(
                          nome: event["description"],
                          telefone: event["phone"],
                          appointmentDate: _appointmentDate,
                          appointmentTime: eventTime),
                    );
                  }
                },
              );
            },
          ),
        );

    return _appointmentsList;
  }

  Future<PacientModel> getPacientByName(String name) async {
    var pacientModel;
    await this
        ._pacientsCollectionReference
        .where(
          "nome",
          isEqualTo: name,
        )
        .where("userId", isEqualTo: _userId)
        .get()
        .then((data) {
      if (data.docs.isNotEmpty) {
        pacientModel = PacientModel.fromMap(data.docs[0].data());
      }
    });

    return pacientModel;
  }

  Future getPacientByCpf(String cpf) async {
    PacientModel pacientModel;
    try {
      var doc =
          await _pacientsCollectionReference.where("cpf", isEqualTo: cpf).get();
      if (doc.docs.isNotEmpty) {
        var pacientsList = doc.docs
            .map((snapshot) => PacientModel.fromMap(snapshot.data()))
            .where((mappedItem) =>
                mappedItem.getNome != null && mappedItem.medicId == _userId)
            .toList();
        pacientModel = pacientsList[0];
      }

      return pacientModel;
    } on Exception catch (e) {
      e.toString();
    }
  }

  Stream listenToPacientsRealTime() {
    this._pacientsCollectionReference.snapshots().listen((pacientsSnapshot) {
      if (pacientsSnapshot.docs.isNotEmpty) {
        var pacients = pacientsSnapshot.docs
            .map((snapshot) => PacientModel.fromMap(snapshot.data()))
            .where((mappedItem) =>
                mappedItem.getNome != null && mappedItem.medicId == _userId)
            .toList();

        this._pacientsController.add(pacients);
        notifyListeners();
      }
    });

    return _pacientsController.stream;
  }

  void listenToPacients() {
    listenToPacientsRealTime().listen((pacientsData) {
      List<PacientModel> updatedPacients = pacientsData;
      if (updatedPacients != null && updatedPacients.length > 0) {
        this._pacients = updatedPacients;
        notifyListeners();
      }
    });
  }

  Future<List<PacientModel>> getPacients() async {
    List<PacientModel> pacientsList = <PacientModel>[];
    pacientsList = await this._pacientsCollectionReference.get().then((resp) {
      return resp.docs
          .map((snapshot) => PacientModel.fromMap(snapshot.data()))
          .where((mappedItem) =>
              mappedItem.getNome != null && mappedItem.medicId == _userId)
          .toList();
    });

    return pacientsList;
  }

  Future<List<PacientModel>> getCPFList(String cpf) async{
    var cpfList = await this._pacientsCollectionReference.get().then((resp){
      return resp.docs
      .map((snapshot) => PacientModel.fromMap(snapshot.data()))
      .where((item) => item.getCpf == cpf)
      .toList();
    });

    return cpfList;
  }
}
