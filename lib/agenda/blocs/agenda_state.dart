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
  final eventsLoaded;

  AgendaLoadSuccess({@required this.eventsLoaded});

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

class AgendaEventsToBeConfirmedProcessing extends AgendaState{
  @override
  List<Object> get props => [];
}

class AgendaEventsToBeConfirmedSuccess extends AgendaState{
  final List eventsConfirmed;
  AgendaEventsToBeConfirmedSuccess({@required this.eventsConfirmed});
  @override
  List<Object> get props => [];

}

class AgendaEventsToBeConfirmedFail extends AgendaState{
  @override
  List<Object> get props => [];

}

class AgendaEventsFilterSuccess extends AgendaState{

  final Map<DateTime, List<dynamic>> eventsFiltered;

  AgendaEventsFilterSuccess({@required this.eventsFiltered});

  @override
  List<Object> get props => throw UnimplementedError();

}
