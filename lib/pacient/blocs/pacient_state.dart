part of 'pacient_bloc.dart';

abstract class PacientState extends Equatable {}

class PacientInicialState extends PacientState {
  @override
  List<Object> get props => [];
}

class CreatePacientEventProcessing extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CreatePacientEventSuccess extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CreatePacientEventFail extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class EditPacientEventSuccess extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class EditPacientEventFail extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class DeletePacientEventSuccess extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class DeletePacientEventFail extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientLoadEventSuccess extends PacientState {
  Map<String, List<dynamic>> _pacientsLoaded;

  PacientLoadEventSuccess(Map<String, List<dynamic>> pacients) {
    this._pacientsLoaded = pacients;
  }

  Map<String, List<dynamic>> get pacientsLoaded => this._pacientsLoaded;

  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientLoadEventFail extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientLoading extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientEventProcessing extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}
