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

  MedRecordLoad({
    @required String pacientCpf,
    @required String pacientSalt,
  }) {
    this._pacientHash = SltPattern.retrivepacientHash(pacientCpf, pacientSalt);
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
