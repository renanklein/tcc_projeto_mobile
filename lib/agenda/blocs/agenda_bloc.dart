import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';

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

      await this.agendaRepository.addEvent(event.eventName, event.eventDay, eventHourRange);
      
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

    else if (event is AgendaEditButtonPressed){
      try{
        yield AgendaEventProcessing();

        var updatedEvent = {
          "id" : event.eventId,
          "begin" : ConvertUtils.fromTimeOfDay(event.eventStart),
          "end" : ConvertUtils.fromTimeOfDay(event.eventEnd),
          "description" : event.eventName
        };

        await this.agendaRepository.updateEvent(event.eventDay, event.eventId, updatedEvent);

        yield AgendaEventEditSuccess();
        
      }catch(error){
        yield AgendaEventEditFail();
      }
    }

    else if(event is AgendaDeleteButtonPressed){
     try{
        yield AgendaEventProcessing();

        await this.agendaRepository.removeEvent(event.eventDay, event.eventId);

        yield AgendaEventDeleteSuccess();
     }catch(error){
       yield AgendaEventDeleteFail();
     }
    }
  }
}
