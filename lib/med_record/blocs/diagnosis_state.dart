part of 'med_record_bloc.dart';

class DiagnosisLoading extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DiagnosisInitialState extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DiagnosisCreateEventProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DiagnosisCreateEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DiagnosisCreateEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DiagnosisLoadEventSuccess extends MedRecordState {
  //List<CompleteDiagnosisModel> _diagnosisLoaded;

  MedRecordModel _medRecord;

  DiagnosisLoadEventSuccess({
    @required MedRecordModel medRecordModel,
  }) {
    this._medRecord = medRecordModel;
  }

  MedRecordModel get medRecordLoaded => this._medRecord;

  @override
  List<Object> get props => [];
}

class DiagnosisLoadEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}
