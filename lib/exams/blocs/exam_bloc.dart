import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
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
        modelMap.addAll({"fields": event.listOfFields});

        await this
            .examRepository
            .saveModelExam(modelMap, event.examTypeMap["Tipo de Exame"]);

        yield CreateExamModelSuccess();
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield CreateExamModelFail(errorMessage: error.toString());
      }
    } else if (event is UpdateExamModel) {
      try {
        yield UpdateExamModelProcessing();

        await this.examRepository.updateExamModels(
            event.examModelType, event.fields, event.oldExamModelType);

        yield UpdateExamModelSuccess();
      } catch (err, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(err, stack_trace);
        yield UpdateExamModelFail(errorMessage: err.toString());
      }
    } else if (event is DeleteExamModel) {
      try {
        yield DeleteExamModelProcessing();

        await this.examRepository.deleteExamModels(event.modelsToBeRemoved);

        yield DeleteExamModelSuccess();
      } catch (err, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(err, stack_trace);
        yield DeleteExamModelFail();
      }
    }else if(event is CreateExamSolicitation){
      try{
        yield ExamSolicitationProcessing();
        await this.examRepository.saveExamSolicitation(event.solicitationExamType, event.solicitationDate, event.pacientHash);
        yield ExamSolicitationSuccess();
      }catch(err, stack_trace){
        await FirebaseCrashlytics.instance.recordError(err, stack_trace);
        yield ExamSolicitationFail();
      }
    } else if(event is GetExamSolicitations){
      try{
        yield GetExamSolicitationsProcessing();

        var solicitations = await this.examRepository.getExamSolictations(event.pacientHash);

        yield GetExamSolicitationsSuccess(solicitations: solicitations);
      }catch(error, stack_trace){
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield ExamSolicitationFail();
      }
    } else if(event is GetExamBySolicitationId){
      yield GetExamBySolicitationIdProcessing();

      var exam = await this.examRepository.getExamBySolicitationId(event.examSolicitationId, event.pacientHash);

      yield GetExamBySolicitationIdSuccess(exam: exam);
    }
  }

  ExamState get initialState => ExamInitial();
}
