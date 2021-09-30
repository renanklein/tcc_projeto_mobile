import 'dart:async';
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

  AgendaBloc({@required this.agendaRepository}) : super(null);

  AgendaState get initialState => AgendaInitial();

  @override
  Stream<AgendaState> mapEventToState(
    AgendaEvent event,
  ) async* {
    if (event is AgendaCreateButtonPressed) {
      try {
        yield EventProcessing();

        var eventHourRange = <String>[];
        eventHourRange.add(event.eventStart);
        eventHourRange.add(event.eventEnd);

        await this.agendaRepository.addEvent(
            event.eventName, event.eventDay, event.eventPhone, eventHourRange);

        yield EventProcessingSuccess();
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        yield EventProcessingFail();
      }
    } else if (event is AgendaLoad) {
      try {
        yield AgendaLoading();

        var events = await this.agendaRepository.getEvents();

        yield AgendaLoadSuccess(eventsLoaded: events);
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        yield AgendaLoadFail();
      }
    } else if (event is AgendaEditButtonPressed) {
      try {
        yield EventProcessing();

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

        yield EventProcessingSuccess();
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        yield EventProcessingFail();
      }
    } else if (event is AgendaDeleteButtonPressed) {
      try {
        yield EventProcessing();

        await this
            .agendaRepository
            .removeEvent(event.eventDay, event.eventId, event.reason);

        yield EventProcessingSuccess();
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        yield EventProcessingFail();
      }
    } else if (event is AgendaEventAvailableTimeLoad) {
      try {
        yield AgendaAvailableTimeLoading();

        var day = ConvertUtils.dayFromDateTime(event.day);

        var occupedHours = await agendaRepository.getOccupedDayTimes(day);

        yield AgendaAvailableTimeSuccess(occupedHours);
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        yield AgendaAvailableTimeFail();
      }
    } else if (event is AgendaEventConfirmButtomPressed) {
      try {
        yield EventProcessing();

        this
            .agendaRepository
            .updateEvent(event.eventDay, event.event, "confirmed");

        yield EventProcessingSuccess();
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        yield EventProcessingFail();
      }
    } else if (event is AgendaEventsToBeConfirmed) {
      try {
        yield AgendaEventsToBeConfirmedProcessing();

        var splited = event.eventDate.contains("-")
            ? event.eventDate.split("-")
            : event.eventDate.split("/");

        var events = await this.agendaRepository.getEventsToBeConfirmed(
            "${splited[2]}-${splited[1]}-${splited[0]}");

        yield AgendaEventsToBeConfirmedSuccess(eventsConfirmed: events);
      } catch (error, stack_trace) {
        await this.crashlytics.recordError(error, stack_trace);
        yield AgendaEventsToBeConfirmedFail();
      }
    } else if (event is AgendaEventsFilter) {
      yield AgendaLoading();

      var eventsFiltered = event.events.map((key, value) {
        var dayEvents = value
            .where((listValue) => listValue.split(";")[1].contains(event.searchString))
            .toList();
        return MapEntry(key, dayEvents);
      });

      yield AgendaEventsFilterSuccess(eventsFiltered: eventsFiltered);
    }
  }
}
