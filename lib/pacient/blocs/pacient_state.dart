part of 'pacient_bloc.dart';

abstract class PacientState extends Equatable {}

class PacientInicialState extends PacientState {
  @override
  List<Object> get props => [];
}

class CreatePacientEventProcessing extends PacientState {}

class CreatePacientEventSuccess extends PacientState {}

class CreatePacientEventFail extends PacientState {}

class EditPacientEventSuccess extends PacientState {}

class EditPacientEventFail extends PacientState {}

class DeletePacientEventSuccess extends PacientState {}

class DeletePacientEventFail extends PacientState {}

class PacientLoadEventSuccess extends PacientState {
  Map<String, List<dynamic>> _pacientsLoaded;

  PacientLoadEventSuccess(Map<String, List<dynamic>> pacients){
    this._pacientsLoaded = pacients;
  }

  Map<String, List<dynamic>> get pacientsLoaded => this._pacientsLoaded;
}

class PacientLoadEventFail extends PacientState {}

class PacientLoading extends PacientState {}

class PacientEventProcessing extends PacientState {}
