import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_hash_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

part 'pacient_event.dart';
part 'pacient_state.dart';
part 'appointment_event.dart';
part 'appointment_state.dart';

class PacientBloc extends Bloc<PacientEvent, PacientState> {
  PacientRepository pacientRepository;

  PacientBloc({@required this.pacientRepository}) : super(null);

  //@override
  PacientState get initialState => PacientInicialState();

  @override
  Stream<PacientState> mapEventToState(
    PacientEvent event,
  ) async* {
    if (event is PacientCreateButtonPressed) {
      try {
        yield CreatePacientEventProcessing();

        PacientHashModel pacientHashModel = SltPattern.pacientHash(event.cpf);

        await this.pacientRepository.createPacient(
                pacient: PacientModel(
              userId: event.userId,
              nome: event.nome,
              email: event.email,
              telefone: event.telefone,
              identidade: event.identidade,
              cpf: event.cpf,
              dtNascimento: event.dtNascimento,
              sexo: event.sexo,
              salt: pacientHashModel.salt,
            ));

        yield CreatePacientEventSuccess();
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield CreatePacientEventFail();
      }
    } else if (event is PacientLoad) {
      try {
        yield PacientLoading();

        var pacientList = await this.pacientRepository.getPacients();

        yield PacientLoadEventSuccess(pacientList);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield PacientLoadEventFail();
      }
    } else if (event is AppointmentsLoad) {
      try {
        yield AppointmentsLoading();

        List<AppointmentModel> _appointmentsList;

        _appointmentsList = await pacientRepository.getAppointments();

        yield AppointmentLoadEventSuccess(_appointmentsList);
      } on Exception catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
      }
    } else if (event is GetPacientByName) {
      try {
        yield PacientLoading();

        var pacient = await this.pacientRepository.getPacientByName(event.name);

        yield GetPacientByNameSuccess(pacient: pacient);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield GetPacientByNameFail();
      }
    }
  }
}
