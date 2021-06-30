import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
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
  final _userModel = Injector.appInstance.get<UserModel>();

  PacientRepository pacientRepository;
  MedRecordRepository medRecordRepository;

  PacientBloc(
      {@required this.pacientRepository, @required this.medRecordRepository})
      : super(null);

  //@override
  PacientState get initialState => PacientInicialState();

  @override
  Stream<PacientState> mapEventToState(
    PacientEvent event,
  ) async* {
    if (event is PacientCreateOrEditButtonPressed) {
      try {
        yield CreateOrEditPacientEventProcessing();

        var cpfList = await this.pacientRepository.getCPFList(event.cpf);

        if (cpfList.isNotEmpty && !event.isUpdate) {
          yield CPFAlreadyExists();
        } else {
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

          if (event.isUpdate) {
            await this.pacientRepository.updatePacient(pacient: _pacientModel);
          } else {
            await this.pacientRepository.createPacient(pacient: _pacientModel);
          }

          yield CreateOrEditPacientEventSuccess(_pacientModel);
        }
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

        var processedAppointments = <AppointmentModel>[];

        await Future.wait(_appointmentsList.map((appointment) async {
          if (appointment.pacientModel != null) {
            var medRecordRepo = Injector.appInstance.get<MedRecordRepository>();
            var pacientHash = SltPattern.retrivepacientHash(
                appointment.pacientModel.getCpf,
                appointment.pacientModel.getSalt);

            var medRecord = await medRecordRepo.getMedRecordByHash(pacientHash);

            var dateFormat = DateFormat("dd/MM/yyyy");

            var appoimentDateAsString =
                dateFormat.format(appointment.appointmentDate);

            medRecord?.getPreDiagnosisList?.forEach((preDiagnosis) {
              if (appoimentDateAsString == preDiagnosis.appointmentEventDate) {
                appointment.hasPreDiagnosis = true;
              }
            });
          }

          processedAppointments.add(appointment);
        }));

        yield AppointmentLoadEventSuccess(processedAppointments);
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
    } else if (event is ViewPacientOverviewButtonPressed) {
      try {
        yield OverviewLoading();
        var _pacientHash = SltPattern.retrivepacientHash(
          event.cpf,
          event.salt,
        );

        if (_userModel.getAccess == "MEDIC" && _pacientHash != null) {
          String overview =
              await this.medRecordRepository.getOverviewByHash(_pacientHash);

          yield ViewPacientOverviewSuccess(overview: overview);
        }

        yield ViewPacientOverviewFailWrongAccess();
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield ViewPacientOverviewFail();
      }
    }
  }
}
