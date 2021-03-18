import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_hash_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../med_record/repositories/med_record_repository.dart';
import '../../utils/slt_pattern.dart';

part 'pacient_event.dart';
part 'pacient_state.dart';
part 'appointment_event.dart';
part 'appointment_state.dart';
part 'pacient_detail_state.dart';
part 'pacient_detail_event.dart';

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

        PacientModel _pacientModel = PacientModel(
          userId: event.userId,
          nome: event.nome,
          email: event.email,
          telefone: event.telefone,
          identidade: event.identidade,
          cpf: event.cpf,
          dtNascimento: event.dtNascimento,
          sexo: event.sexo,
          salt: pacientHashModel.salt,
        );

        await this.pacientRepository.createPacient(pacient: _pacientModel);

        yield CreatePacientEventSuccess(_pacientModel);
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
    } else if (event is PacientDetailLoad) {
      try {
        yield PacientDetailLoading();

        PacientModel _pacientDetail;

        _pacientDetail = await pacientRepository
            .getPacientByNameAndPhone(event._appointmentModel);

        if (_pacientDetail != null) {
          var medRecordRepo = Injector.appInstance.get<MedRecordRepository>();
          var pacientHash = SltPattern.retrivepacientHash(
              _pacientDetail.getCpf, _pacientDetail.getSalt);

          var medRecord = await medRecordRepo.getMedRecordByHash(pacientHash);

          var dateFormat = DateFormat("dd/MM/yyyy");

          var hasPreDiagnosis = false;
          var appoimentDateAsString =
              dateFormat.format(event._appointmentModel.appointmentDate);

          medRecord?.getPreDiagnosisList?.forEach((preDiagnosis) {
            if (appoimentDateAsString == preDiagnosis.appointmentEventDate) {
              hasPreDiagnosis = true;
            }
          });

          if (hasPreDiagnosis) {
            yield PacientDetailWithPreDiagnosisSuccess(
                pacientModel: _pacientDetail,
                preDiagnosisDate: appoimentDateAsString);
          } else {
            yield PacientDetailLoadEventSuccess(_pacientDetail);
          }
        } else {
          yield PacientDetailLoadEventFail();
        }
      } on Exception catch (e) {
        yield PacientDetailLoadEventFail();
        e.toString();
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
