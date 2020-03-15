part of 'agenda_bloc.dart';

abstract class AgendaEvent extends Equatable {

}

class AgendaCreateButtonPressed extends AgendaEvent{
  String eventName;
  DateTime eventDay;
  TimeOfDay eventStart;
  TimeOfDay eventEnd;

  AgendaCreateButtonPressed({
    @required this.eventName, 
    @required this.eventDay,
    @required this.eventStart,
    @required this.eventEnd});
}

class AgendaLoad extends AgendaEvent{
  
}
