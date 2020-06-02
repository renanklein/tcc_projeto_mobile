part of 'agenda_bloc.dart';

abstract class AgendaState extends Equatable {

}

class AgendaInitial extends AgendaState {
  @override
  List<Object> get props => [];
}

class EventProcessing extends AgendaState{}

class EventProcessingSuccess extends AgendaState{}

class EventProcessingFail extends AgendaState{}


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

class AgendaAvailableTimeLoading extends AgendaState{

}

class AgendaAvailableTimeSuccess extends AgendaState{
  List<String> _occupedTimes;

  AgendaAvailableTimeSuccess(List<String> times){
    this._occupedTimes = times;
  }

  List<String> get occupedTimes => this._occupedTimes;
}

class AgendaAvailableTimeFail extends AgendaState{

}



