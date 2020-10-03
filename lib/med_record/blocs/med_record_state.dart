part of 'med_record_bloc.dart';

abstract class MedRecordState extends Equatable {}

class MedRecordInicialState extends MedRecordState {
  @override
  List<Object> get props => [];
}

class CreateMedRecordEventProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class CreateMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class CreateMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class EditMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class EditMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DeleteMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DeleteMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordLoadEventSuccess extends MedRecordState {
  MedRecordModel _medRecordLoaded;

  MedRecordLoadEventSuccess({@required MedRecordModel medRecord}) {
    this._medRecordLoaded = medRecord;
  }

  MedRecordModel get medRecordLoaded => this._medRecordLoaded;

  @override
  List<Object> get props => [];
}

class MedRecordLoadEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordLoading extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordEventProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordEventFailure extends MedRecordState {
  @override
  List<Object> get props => [];
}
