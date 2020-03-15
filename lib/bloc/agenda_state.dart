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

class AgendaLoadSuccess extends AgendaState{

}

class AgendaLoadFail extends AgendaState{

}


