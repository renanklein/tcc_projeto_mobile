part of 'med_record_bloc.dart';

abstract class MedRecordEvent extends Equatable {}

class MedRecordCreateButtonPressed extends MedRecordEvent {
  //final userId;

  MedRecordCreateButtonPressed(//@required this.userId,

      );

  @override
  List<Object> get props => throw UnimplementedError();
}

class MedRecordLoad extends MedRecordEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class MedRecordEditButtonPressed extends MedRecordEvent {
  MedRecordEditButtonPressed();

  @override
  List<Object> get props => throw UnimplementedError();
}

class MedRecordDeleteButtonPressed extends MedRecordEvent {
  MedRecordDeleteButtonPressed();

  @override
  List<Object> get props => throw UnimplementedError();
}
