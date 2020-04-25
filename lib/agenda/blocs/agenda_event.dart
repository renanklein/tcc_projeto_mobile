part of 'agenda_bloc.dart';

abstract class AgendaEvent extends Equatable {

}

class AgendaCreateButtonPressed extends AgendaEvent{
  String eventName;
  DateTime eventDay;
  String eventStart;
  String eventEnd;

  AgendaCreateButtonPressed({
    @required this.eventName, 
    @required this.eventDay,
    @required this.eventStart,
    @required this.eventEnd});
}

class AgendaLoad extends AgendaEvent{
  
}

class AgendaEditButtonPressed extends AgendaEvent{
  String eventId;
  String eventName;
  DateTime eventDay;
  String eventStart;
  String eventEnd;

  AgendaEditButtonPressed({
    @required this.eventId,
    @required this.eventName, 
    @required this.eventDay,
    @required this.eventStart,
    @required this.eventEnd});
}

class AgendaDeleteButtonPressed extends AgendaEvent{
  String eventId;
  DateTime eventDay;
  String reason;

  AgendaDeleteButtonPressed({
    @required this.eventId,
    @required this.eventDay,
    @required this.reason
  });
}

class AgendaEventAvailableTimeLoad extends AgendaEvent{
    DateTime day;

    AgendaEventAvailableTimeLoad({
      @required this.day
    });
}
