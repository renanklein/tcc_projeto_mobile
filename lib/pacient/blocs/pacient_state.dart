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
  PacientModel _createdPacient;

  CreatePacientEventSuccess(PacientModel pacientModel) {
    this._createdPacient = pacientModel;
  }

  PacientModel get pacientCreated => this._createdPacient;

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
  List<PacientModel> _pacientsLoaded;

  PacientLoadEventSuccess(List<PacientModel> pacients) {
    this._pacientsLoaded = pacients;
    this._pacientsLoaded.sort((a, b) => a.getNome.compareTo(b.getNome));
  }

  List<PacientModel> get pacientsLoaded => this._pacientsLoaded;

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

class GetPacientByNameSuccess extends PacientState {
  final pacient;

  GetPacientByNameSuccess({@required this.pacient});

  @override
  List<Object> get props => throw UnimplementedError();
}

class GetPacientByNameFail extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}
