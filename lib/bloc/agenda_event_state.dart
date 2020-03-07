part of 'agenda_event_bloc.dart';

abstract class AgendaEventState extends Equatable {

}

class AgendaEventInitial extends AgendaEventState {
  @override
  List<Object> get props => [];
}

class AgendaEventProcessing extends AgendaEventState{

}

class AgendaEventCreateSuccess extends AgendaEventState{
  
}

class AgendaEventCreateFail extends AgendaEventState{
  
}


