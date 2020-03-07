part of 'agenda_event_bloc.dart';

abstract class AgendaEventEvent extends Equatable {

}

class AgendaCreateButtonPressed extends AgendaEventEvent{
  String eventName;
  DateTime eventDate;

  AgendaCreateButtonPressed({@required this.eventName, @required this.eventDate});
}
