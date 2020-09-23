part of 'med_record_bloc.dart';

abstract class MedRecordEvent extends Equatable {}

class MedRecordCreateButtonPressed extends MedRecordEvent {
  final pacientHash;

  MedRecordCreateButtonPressed(
    this.pacientHash,
  );

  @override
  List<Object> get props => [];
}

class MedRecordLoad extends MedRecordEvent {
  String _pacientHash;

  MedRecordLoad({@required String pacientHash}) {
    this._pacientHash = pacientHash;
  }

  String get getPacientHash => this._pacientHash;

  @override
  List<Object> get props => [];
}

class MedRecordEditButtonPressed extends MedRecordEvent {
  MedRecordEditButtonPressed();

  @override
  List<Object> get props => [];
}

class MedRecordDeleteButtonPressed extends MedRecordEvent {
  MedRecordDeleteButtonPressed();

  @override
  List<Object> get props => [];
}
