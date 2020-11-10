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

  Future<List<AppointmentModel>> getAppointments() async {
    List<AppointmentModel> _appointmentsList = new List<AppointmentModel>();
    var docs;
    await _agendaCollectionReference
        .doc(this._userId)
        .collection("events")
        .get()
        .then(
          (resp) => resp.docs.forEach(
            (snapshot) {
              var events = snapshot.data().values.first;
              var snapId = snapshot.id;
              var _appointmentTime = DateTime(
                  int.parse(snapId.split("-")[0]),
                  int.parse(snapId.split("-")[1]),
                  int.parse(snapId.split("-")[2]));

              events.forEach(
                (event) {
                  if (event["status"] != "canceled") {
                    _appointmentsList.add(
                      AppointmentModel(
                        nome: event["description"],
                        telefone: event["phone"],
                        appointmentTime: _appointmentTime,
                      ),
                    );
                  }
                },
              );
            },
          ),
        );

    return _appointmentsList;
  }

  Future getPacientByName(String name) async {}

  void listenToPacients() {
    listenToPacientsRealTime().listen((pacientsData) {
      List<PacientModel> updatedPacients = pacientsData;
      if (updatedPacients != null && updatedPacients.length > 0) {
        _pacients = updatedPacients;
        notifyListeners();
      }
    });
  }

// TODO: iterar paciente pelo ID do médico

  Stream listenToPacientsRealTime() {
    _pacientsCollectionReference.snapshots().listen((pacientsSnapshot) {
      if (pacientsSnapshot.docs.isNotEmpty) {
        var pacients = pacientsSnapshot.docs
            .map((snapshot) => PacientModel.fromMap(snapshot.data()))
            .where((mappedItem) => mappedItem.nome != null)
            .toList();

        _pacientsController.add(pacients);
        notifyListeners();
      }
    });

    return _pacientsController.stream;
  }
}
