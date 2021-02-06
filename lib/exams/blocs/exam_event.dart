part of 'exam_bloc.dart';

abstract class ExamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateExamModel extends ExamEvent {
  final listOfFields;
  final examTypeMap;

  CreateExamModel({@required this.listOfFields, @required this.examTypeMap});
}

class UpdateExamModel extends ExamEvent {
  final fields;
  final examModelType;
  final oldExamModelType;

  UpdateExamModel(
      {@required this.fields,
      @required this.examModelType,
      @required this.oldExamModelType});
}

class DeleteExamModel extends ExamEvent {
  final List modelsToBeRemoved;

  DeleteExamModel({@required this.modelsToBeRemoved});
}
