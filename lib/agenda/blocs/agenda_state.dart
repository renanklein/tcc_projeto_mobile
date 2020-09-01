part of 'agenda_bloc.dart';

abstract class AgendaState extends Equatable {}

class AgendaInitial extends AgendaState {
  @override
  List<Object> get props => [];
}

class EventProcessing extends AgendaState {
  @override
  List<Object> get props => [];
}

class EventProcessingSuccess extends AgendaState {
  @override
  List<Object> get props => [];
}

class EventProcessingFail extends AgendaState {
  @override
  List<Object> get props => [];
}

class AgendaLoadSuccess extends AgendaState {
  Map<DateTime, List<dynamic>> _eventsLoaded;

  AgendaLoadSuccess(Map<DateTime, List<dynamic>> events) {
    this._eventsLoaded = events;
  }

  Map<DateTime, List<dynamic>> get eventsLoaded => this._eventsLoaded;

  @override
  List<Object> get props => [];
}

class AgendaLoadFail extends AgendaState {
  @override
  List<Object> get props => [];
}

class AgendaLoading extends AgendaState {
  @override
  List<Object> get props => [];
}

class AgendaAvailableTimeLoading extends AgendaState {
  @override
  List<Object> get props => [];
}

class AgendaAvailableTimeSuccess extends AgendaState {
  List<String> _occupedTimes;

  AgendaAvailableTimeSuccess(List<String> times) {
    this._occupedTimes = times;
  }

  List<String> get occupedTimes => this._occupedTimes;

  @override
  List<Object> get props => [];
}

class AgendaAvailableTimeFail extends AgendaState {
  @override
  List<Object> get props => [];
}
