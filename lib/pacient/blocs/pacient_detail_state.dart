part of 'pacient_bloc.dart';

class PacientDetailLoading extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientDetailLoadEventSuccess extends PacientState {
  PacientModel _pacientDetailLoaded;

  PacientDetailLoadEventSuccess(PacientModel pacientDetail) {
    this._pacientDetailLoaded = pacientDetail;
  }

  PacientModel get pacientDetailLoaded => this._pacientDetailLoaded;

  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientDetailLoadEventFail extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}
