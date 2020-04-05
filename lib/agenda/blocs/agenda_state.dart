part of 'agenda_bloc.dart';

abstract class AgendaState extends Equatable {

}

class AgendaInitial extends AgendaState {
  @override
  List<Object> get props => [];
}

class AgendaEventProcessing extends AgendaState{

}

class AgendaEventCreateSuccess extends AgendaState{
  
}

class AgendaEventCreateFail extends AgendaState{
  
}

class AgendaEventEditSuccess extends AgendaState{

}

class AgendaEventEditFail extends AgendaState{

}

class AgendaEventDeleteSuccess extends AgendaState{

}

class AgendaEventDeleteFail extends AgendaState{
  
}

class AgendaLoadSuccess extends AgendaState{
  Map<DateTime, List<dynamic>> _eventsLoaded;

  AgendaLoadSuccess(Map<DateTime, List<dynamic>> events){
    this._eventsLoaded = events;
  }

  Map<DateTime, List<dynamic>> get eventsLoaded => this._eventsLoaded;  
}

class AgendaLoadFail extends AgendaState{

}

class AgendaLoading extends AgendaState{
  
}


