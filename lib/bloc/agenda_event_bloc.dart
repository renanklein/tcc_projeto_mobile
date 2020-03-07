import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/repository/agenda_repository.dart';

part 'agenda_event_event.dart';
part 'agenda_event_state.dart';

class AgendaEventBloc extends Bloc<AgendaEventEvent, AgendaEventState> {

  AgendaRepository agendaRepository;

  AgendaEventBloc({@required this.agendaRepository});

  @override
  AgendaEventState get initialState => AgendaEventInitial();

  @override
  Stream<AgendaEventState> mapEventToState(
    AgendaEventEvent event,
  ) async* {
    if(event is AgendaCreateButtonPressed){
     try{
      yield AgendaEventProcessing();
      this.agendaRepository.addEvent(event.eventName, event.eventDate);
      yield AgendaEventCreateSuccess();
     }
     catch(error){
       yield AgendaEventCreateFail();
     }
    }
  }
}
