part of 'agenda_bloc.dart';

abstract class AgendaEvent extends Equatable {}

class AgendaCreateButtonPressed extends AgendaEvent {
  final eventName;
  final eventDay;
  final eventStart;
  final eventEnd;

  AgendaCreateButtonPressed(
      {@required this.eventName,
      @required this.eventDay,
      @required this.eventStart,
      @required this.eventEnd});

  @override
  List<Object> get props => [];
}

class AgendaLoad extends AgendaEvent {
  @override
  List<Object> get props => [];
}

class AgendaEditButtonPressed extends AgendaEvent {
  final eventId;
  final eventName;
  final eventDay;
  final eventStart;
  final eventEnd;
  final eventStatus;

  AgendaEditButtonPressed(
      {@required this.eventId,
      @required this.eventName,
      @required this.eventDay,
      @required this.eventStart,
      @required this.eventEnd,
      @required this.eventStatus});

  @override
  List<Object> get props => [];
}

class AgendaDeleteButtonPressed extends AgendaEvent {
  final eventId;
  final eventDay;
  final reason;

  AgendaDeleteButtonPressed(
      {@required this.eventId, @required this.eventDay, @required this.reason});

  @override
  List<Object> get props => [];
}

class AgendaEventAvailableTimeLoad extends AgendaEvent {
  final day;

  AgendaEventAvailableTimeLoad({@required this.day});

  @override
  List<Object> get props => [];
}

class AgendaEventConfirmButtomPressed extends AgendaEvent {
  final event;
  final eventDay;

  AgendaEventConfirmButtomPressed(
      {@required this.event, @required this.eventDay});

  @override
  List<Object> get props => [];
}
