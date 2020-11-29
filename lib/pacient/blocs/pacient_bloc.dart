import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_hash_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';

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
      } catch (error) {
        yield CreatePacientEventFail();
      }
    } else if (event is PacientLoad) {
      try {
        yield PacientLoading();

        this.pacientRepository.listenToPacients();

        yield PacientLoadEventSuccess(pacientRepository.pacientsList);
      } catch (error) {
        yield PacientLoadEventFail();
      }
    } else if (event is AppointmentsLoad) {
      try {
        yield AppointmentsLoading();

        List<AppointmentModel> _appointmentsList;

        _appointmentsList = await pacientRepository.getAppointments();

        yield AppointmentLoadEventSuccess(_appointmentsList);
      } on Exception catch (e) {
        e.toString();
      }
    }
    /* else if (event is PacientEditButtonPressed) {
      try {
        yield PacientEventProcessing();

        var updatedPacient = {
          'nome': event.nome,
          'email': event.email,
          'telefone': event.telefone,
          'identidade': event.identidade,
          'cpf': event.cpf,
          'dtNascimento': event.dtNascimento,
          'sexo': event.sexo,
        };

        await this.pacientRepository.updatePacient(
            nome: event.nome,
            email: event.email,
            telefone: event.telefone,
            identidade: event.identidade,
            cpf: event.cpf,
            dtNascimento: event.dtNascimento,
            sexo: event.sexo);

        yield EditPacientEventSuccess();
      } catch (error) {
        yield EditPacientEventFail();
      }
    } else if (event is PacientDeleteButtonPressed) {
      try {
        yield PacientEventProcessing();

        //await this.pacientRepository.removePacient(event.pacientId);

        yield DeletePacientEventSuccess();
      } catch (error) {
        yield DeletePacientEventFail();
      }
    }*/
  }
}
