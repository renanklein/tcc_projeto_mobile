import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';

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

  Future updatePacient({@required PacientModel pacient}) async {
    var doc = await this
        ._pacientsCollectionReference
        .where("cpf", isEqualTo: pacient.getCpf)
        .get();

    await this
        ._pacientsCollectionReference
        .doc(doc.docs[0].id)
        .update(pacient.toMap());
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

  Future updateAppointmentDate(
      AppointmentModel appointment, DateTime newDate, String newTime) async {
    var oldDateSnapshot = _agendaCollectionReference
        .doc(this._userId)
        .collection('events')
        .doc(ConvertUtils.dayFromDateTime(appointment.appointmentDate))
        .get();

    var newDateSnapshot = _agendaCollectionReference
        .doc(this._userId)
        .collection('events')
        .doc(ConvertUtils.dayFromDateTime(newDate))
        .get();

    var resolvedFutures =
        await Future.wait(<Future>[oldDateSnapshot, newDateSnapshot]);

    var appointmentEvent = Map();

    DocumentSnapshot oldDateDocument = resolvedFutures[0];
    DocumentSnapshot newDateDocument = resolvedFutures[1];

    var oldDateEventsData = oldDateDocument.data();
    var newDateEventsData = newDateDocument.data();

    for (var event in oldDateEventsData['events']) {
      if (appointment.appointmentTime ==
          "${event['begin']} - ${event['end']}") {
        appointmentEvent = event;
      }
    }

    oldDateEventsData['events'].remove(appointmentEvent);

    appointmentEvent['begin'] = newTime.replaceAll(' ', '').split('-')[0];
    appointmentEvent['end'] = newTime.replaceAll(' ', '').split('-')[1];

    if (newDateEventsData != null) {
      newDateEventsData['events'].add(appointmentEvent);
    } else {
      newDateEventsData = {
        "events": [appointmentEvent]
      };
    }

    var saveOldDateEvents = _agendaCollectionReference
        .doc(this._userId)
        .collection('events')
        .doc(ConvertUtils.dayFromDateTime(appointment.appointmentDate))
        .set(oldDateEventsData);

    var saveNewDateEvents = _agendaCollectionReference
        .doc(this._userId)
        .collection('events')
        .doc(ConvertUtils.dayFromDateTime(newDate))
        .set(newDateEventsData);

    await Future.wait(<Future>[saveNewDateEvents, saveOldDateEvents]);
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

    var appointments = <AppointmentModel>[];
    await Future.wait(_appointmentsList.map((appointment) async {
      var pacient = await getPacientByNameAndPhone(appointment);
      appointment.pacientModel = pacient;
      appointments.add(appointment);
    }));

    return appointments;
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

  Future<List<PacientModel>> getCPFList(String cpf) async {
    var cpfList = await this._pacientsCollectionReference.get().then((resp) {
      return resp.docs
          .map((snapshot) => PacientModel.fromMap(snapshot.data()))
          .where((item) => item.getCpf == cpf)
          .toList();
    });

    return cpfList;
  }
}
