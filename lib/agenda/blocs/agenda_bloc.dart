import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

part 'agenda_event.dart';
part 'agenda_state.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  AgendaRepository agendaRepository;
  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  AgendaBloc({@required this.agendaRepository}) : super(null){
    on<AgendaCreateButtonPressed>((event, emit) async{
      try {
        emit(EventProcessing());

        var eventHourRange = <String>[];
        eventHourRange.add(event.eventStart);
        eventHourRange.add(event.eventEnd);

        await this.agendaRepository.addEvent(
            event.eventName, event.eventDay, event.eventPhone, eventHourRange);


        emit(EventProcessingSuccess());
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        emit(EventProcessingFail());
      }
    });

    on<AgendaLoad>((event, emit) async{
      try {
        emit(AgendaLoading());

        var events = await this.agendaRepository.getEvents();

        emit(AgendaLoadSuccess(eventsLoaded: events));
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        emit(AgendaLoadFail());
      }
    });

    on<AgendaEditButtonPressed>((event, emit) async{
      try {
        emit(EventProcessing());

        var updatedEvent = {
          "id": event.eventId,
          "begin": event.eventStart,
          "end": event.eventEnd,
          "description": event.eventName,
          "phone": event.eventPhone
        };

        await this
            .agendaRepository
            .updateEvent(event.eventDay, updatedEvent, event.eventStatus);

        emit(EventProcessingSuccess());
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        emit(EventProcessingFail());
      }
    });

    on<AgendaDeleteButtonPressed>((event, emit) async{
       try {
        emit(EventProcessing());

        await this
            .agendaRepository
            .removeEvent(event.eventDay, event.eventId, event.reason);

        emit(EventProcessingSuccess());
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        emit(EventProcessingFail());
      }
    });

    on<AgendaEventAvailableTimeLoad>((event, emit) async{
       try {
        emit(AgendaAvailableTimeLoading());

        var day = ConvertUtils.dayFromDateTime(event.day);

        var occupedHours = await agendaRepository.getOccupedDayTimes(day);

        emit(AgendaAvailableTimeSuccess(occupedHours));
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        emit(AgendaAvailableTimeFail());
      }
    });

    on<AgendaEventConfirmButtomPressed>((event, emit) async{
       try {
        emit(EventProcessing());

        this
            .agendaRepository
            .updateEvent(event.eventDay, event.event, "confirmed");

        emit(EventProcessingSuccess());
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        emit(EventProcessingFail());
      }
    });

    on<AgendaEventsToBeConfirmed>((event, emit)async{
       try {
        emit(AgendaEventsToBeConfirmedProcessing());

        var splited = event.eventDate.contains("-")
            ? event.eventDate.split("-")
            : event.eventDate.split("/");

        var events = await this.agendaRepository.getEventsToBeConfirmed(
            "${splited[2]}-${splited[1]}-${splited[0]}");


        emit(AgendaEventsToBeConfirmedSuccess(eventsConfirmed: events));
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        emit(AgendaEventsToBeConfirmedFail());
      }
    });

    on<AgendaEventsFilter>((event, emit){
      emit(AgendaLoading());

      var eventsFiltered = event.events.map((key, value) {
        var dayEvents = value
            .where(
              (listValue) => listValue.split(";")[1].toLowerCase().contains(
                    event.searchString.toLowerCase(),
                  ),
            )
            .toList();
        return MapEntry(key, dayEvents);
      });

      emit(AgendaEventsFilterSuccess(eventsFiltered: eventsFiltered));
    });
  }

  AgendaState get initialState => AgendaInitial();
}
