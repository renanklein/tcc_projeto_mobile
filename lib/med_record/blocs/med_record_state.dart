part of 'med_record_bloc.dart';

abstract class MedRecordState extends Equatable {}

class MedRecordInicialState extends MedRecordState {
  @override
  List<Object> get props => [];
}

class CreateMedRecordEventProcessing extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CreateMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CreateMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class EditMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class EditMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class DeleteMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class DeleteMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class MedRecordLoadEventSuccess extends MedRecordState {
  Map<String, List<dynamic>> _medRecordsLoaded;

  MedRecordLoadEventSuccess(Map<String, List<dynamic>> medRecords) {
    this._medRecordsLoaded = medRecords;
  }

  Map<String, List<dynamic>> get medRecordsLoaded => this._medRecordsLoaded;

  @override
  List<Object> get props => throw UnimplementedError();
}

class MedRecordLoadEventFail extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class MedRecordLoading extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class MedRecordEventProcessing extends MedRecordState {
  @override
  List<Object> get props => throw UnimplementedError();
}
