part of 'agenda_bloc.dart';

abstract class AgendaEvent extends Equatable {

}

class AgendaCreateButtonPressed extends AgendaEvent{
  String eventName;
  DateTime eventDate;

  AgendaCreateButtonPressed({@required this.eventName, @required this.eventDate});
}

class AgendaLoad extends AgendaEvent{
  
}
