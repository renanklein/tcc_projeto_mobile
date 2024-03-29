part of 'exam_bloc.dart';

abstract class ExamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateExamModel extends ExamEvent {
  final mapOfFields;
  final examTypeMap;

  CreateExamModel({@required this.mapOfFields, @required this.examTypeMap});
}

class UpdateExamModel extends ExamEvent {
  final mapOfFields;
  final examModelType;
  final oldExamModelType;

  UpdateExamModel(
      {@required this.mapOfFields,
      @required this.examModelType,
      @required this.oldExamModelType});
}

class DeleteExamModel extends ExamEvent {
  final List modelsToBeRemoved;

  DeleteExamModel({@required this.modelsToBeRemoved});
}

class CreateExamSolicitation extends ExamEvent{
  final String solicitationDate;
  final String solicitationExamType;
  final String pacientHash;

  CreateExamSolicitation({@required this.solicitationDate, @required this.solicitationExamType, @required this.pacientHash});
}

class GetExamSolicitations extends ExamEvent {
  final String pacientHash;

  GetExamSolicitations({@required this.pacientHash});
}

class GetExamBySolicitationId extends ExamEvent {
  final String examSolicitationId;
  final String pacientHash;

  GetExamBySolicitationId({@required this.examSolicitationId, @required this.pacientHash});
}

class ExistsExamModel extends ExamEvent{
  final String examType;

  ExistsExamModel({@required this.examType});
  
}
