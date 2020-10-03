import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/prescription_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';

part 'med_record_event.dart';
part 'med_record_state.dart';
part 'exam_state.dart';
part 'exam_event.dart';
part 'diagnosis_state.dart';
part 'diagnosis_event.dart';

class MedRecordBloc extends Bloc<MedRecordEvent, MedRecordState> {
  MedRecordRepository medRecordRepository;
  ExamRepository examRepository;

  MedRecordBloc({
    @required this.medRecordRepository,
    this.examRepository,
  }) : super(null);

  MedRecordState get initialState => MedRecordInicialState();

  @override
  Stream<MedRecordState> mapEventToState(
    MedRecordEvent event,
  ) async* {
    if (event is MedRecordCreateButtonPressed) {
      try {
        yield CreateMedRecordEventProcessing();

        //TODO: Inserção itens Prontuario

        await medRecordRepository.updateMedRecord(
            pacientHash: event.pacientHash,
            medRecordModel: MedRecordModel(pacientHash: '22'));

        yield CreateMedRecordEventSuccess();
      } catch (error) {
        yield CreateMedRecordEventFail();
      }
    } else if (event is DiagnosisCreateButtonPressed) {
      try {
        yield MedRecordEventProcessing();

        var now = new DateTime.now();
        var dateFormat = DateFormat("dd/MM/yyyy");
        var hoje = dateFormat.format(now);

        await this.medRecordRepository.createPacientDiagnosis(
            completeDiagnosisModel: CompleteDiagnosisModel(
                problem: ProblemModel(
                    description: event.problemDescription,
                    problemId: event.problemId),
                diagnosis: DiagnosisModel(
                    description: event.diagnosisDescription,
                    cid: event.diagnosisCid),
                prescription: PrescriptionModel(
                    medicine: event.prescriptionMedicine,
                    dosage: event.prescriptionDosage,
                    dosageForm: event.prescriptionDosageForm,
                    usageOrientation: event.prescriptionUsageOrientation,
                    usageDuration: event.prescriptionUsageDuration)),
            date: hoje);

        yield MedRecordEventSuccess();
      } catch (error) {
        yield MedRecordEventFailure();
      }
    } else if (event is MedRecordLoad) {
      try {
        yield MedRecordLoading();

        MedRecordModel medRecord = await this
            .medRecordRepository
            .getMedRecordByCpf(event.getPacientHash);

        yield MedRecordLoadEventSuccess(medRecord: medRecord);
      } catch (error) {
        yield MedRecordLoadEventFail();
      }
    } else if (event is MedRecordEditButtonPressed) {
      try {} catch (error) {}
    } else if (event is MedRecordDeleteButtonPressed) {
      try {} catch (error) {}
    }
    if (event is SaveExam) {
      try {
        yield ExamProcessing();

        var examBytes = await event.getExamFile.readAsBytes();

        var encoded = base64.encode(examBytes);

        String dir = (await getApplicationDocumentsDirectory()).path;
        var randomFileName = Random.secure().nextInt(10000);
        var filePath = "$dir/$randomFileName.txt";
        var encriptedFile = File("$dir/$randomFileName.txt");
        await encriptedFile.writeAsString(encoded);

        await this
            .examRepository
            .saveExam(event.getCardExamInfo, event.getExamDetails, filePath);

        yield ExamProcessingSuccess(encriptedFile: encriptedFile);
      } catch (error) {
        yield ExamProcessingFail();
      }
    } else if (event is GetExams) {
      try {
        yield ExamProcessing();

        var examInfoList = await this.examRepository.getExam();

        List examCards = [];
        List examDetails = [];
        List examFilePaths = [];

        for (int i = 0; i < examInfoList.length; i += 3) {
          examCards.add(examInfoList[i]);
          examDetails.add(examInfoList[i + 1]);
          examFilePaths.add(examInfoList[i + 2]);
        }
        yield GetExamsSuccess(
            cardExamInfos: examCards,
            examDetailsList: examDetails,
            filePaths: examFilePaths);
      } catch (error) {
        yield ExamProcessingFail();
      }
    } else if (event is DecriptExam) {
      try {
        yield ExamProcessing();

        var filePath = event.filePath;

        var file = File(filePath);
        var bytes = await file.readAsString();
        var decriptedBytes = base64.decode(bytes);

        yield DecriptExamSuccess(decriptedBytes: decriptedBytes);
      } catch (error) {
        yield ExamProcessingFail();
      }
    }
  }
}
