import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/repository/agenda_repository.dart';

part 'agenda_event.dart';
part 'agenda_state.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {

  AgendaRepository agendaRepository;

  AgendaBloc({@required this.agendaRepository});

  @override
  AgendaState get initialState => AgendaInitial();

  @override
  Stream<AgendaState> mapEventToState(
    AgendaEvent event,
  ) async* {
    if(event is AgendaCreateButtonPressed){
     try{
      yield AgendaEventProcessing();

      var eventHourRange = new List<TimeOfDay>();
      eventHourRange.add(event.eventStart);
      eventHourRange.add(event.eventEnd);

      this.agendaRepository.addEvent(event.eventName, event.eventDay, eventHourRange);
      
      yield AgendaEventCreateSuccess();
     }
     catch(error){
       yield AgendaEventCreateFail();
     }
    }

    else if(event is AgendaLoad){
      try{
        yield AgendaLoading();

        var events = await this.agendaRepository.getEvents();

        yield AgendaLoadSuccess(events);
      }catch(error){
        yield AgendaLoadFail();
      }
    }
  }
}
