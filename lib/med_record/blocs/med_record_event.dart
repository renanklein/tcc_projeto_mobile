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
  String hash;

  MedRecordLoad({@required String hash});

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
