import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final _encripKey = encryptLib.Key.fromSecureRandom(16);
  ExamRepository examRepository;

  ExamBloc({@required this.examRepository}) : super(null);

  @override
  Stream<ExamState> mapEventToState(
    ExamEvent event,
  ) async* {
    if (event is CreateExamModel) {
      try {
        yield CreateExamModelProcessing();

        var modelMap = Map<String, dynamic>();
        modelMap.addAll(event.examTypeMap);
        modelMap.addAll(event.examDateMap);
        modelMap.addAll({"fields": event.listOfFields});

        await this
            .examRepository
            .saveModelExam(modelMap, event.examTypeMap["Tipo de Exame"]);

        yield CreateExamModelSuccess();
      } catch (error) {
        yield CreateExamModelFail(errorMessage: error.toString());
      }
    }
  }

  @override
  ExamState get initialState => ExamInitial();
}
