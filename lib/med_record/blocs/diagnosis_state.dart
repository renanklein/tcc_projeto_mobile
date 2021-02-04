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
  List<CompleteDiagnosisModel> _diagnosisLoaded;

  DiagnosisLoadEventSuccess(
      {@required List<CompleteDiagnosisModel> diagnosisModels}) {
    this._diagnosisLoaded = diagnosisModels;
  }

  List<CompleteDiagnosisModel> get medRecordLoaded => this._diagnosisLoaded;

  @override
  List<Object> get props => [];
}

class DiagnosisLoadEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}
