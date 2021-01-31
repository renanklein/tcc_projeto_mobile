import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_details_field.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/prescription_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';

part 'med_record_event.dart';
part 'med_record_state.dart';
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

        await medRecordRepository.updateMedRecord(
            pacientHash: event.pacientHash,
            medRecordModel: MedRecordModel(pacientHash: '22'));

        yield CreateMedRecordEventSuccess();
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
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
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield MedRecordEventFailure();
      }
    } else if (event is MedRecordLoad) {
      try {
        yield MedRecordLoading();

        MedRecordModel medRecord = await this
            .medRecordRepository
            .getMedRecordByHash(event.getPacientHash);

        yield MedRecordLoadEventSuccess(medRecord: medRecord);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
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
        var encriptedFile;
        var randomFileName;
        // For Encrypt/Decrypt purposes
        var initializationVector = IV.fromSecureRandom(16);

        if (event.getExamFile != null) {
          var examBytes = await event.getExamFile.readAsBytes();

          var keyUrl = await this.examRepository.getCryptoKeyDownload();

          var keyResponse = await http.get(keyUrl);
          var base64Key = keyResponse.body;
          var encoded = SltPattern.encryptImageBytes(
              examBytes, initializationVector, base64Key);

          var tempDir = await getTemporaryDirectory();
          var tempPath = tempDir.path;
          randomFileName = Random.secure().nextInt(10000);
          var fileName = randomFileName.toString();
          encriptedFile = File("$tempPath/$fileName");

          await encriptedFile.writeAsString(encoded);
        }

        var pacientHash = SltPattern.retrivepacientHash(
            event.getMedRecordArguments.pacientCpf,
            event.getMedRecordArguments.pacientSalt);

        await this.examRepository.saveExam(
            event.getCardExamInfo,
            event.getExamDetails,
            encriptedFile,
            randomFileName.toString(),
            pacientHash,
            initializationVector);

        yield ExamProcessingSuccess(encriptedFile: encriptedFile);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield ExamProcessingFail();
      }
    } else if (event is GetExams) {
      try {
        yield ExamProcessing();

        var examInfoList = await this.examRepository.getExam(event.pacientHash);

        List examCards = [];
        List examDetails = [];
        List examFileDownloadURLs = [];
        List ivs = [];

        for (int i = 0; i < examInfoList.length; i += 4) {
          examCards.add(examInfoList[i]);
          examDetails.add(examInfoList[i + 1]);
          examFileDownloadURLs.add(examInfoList[i + 2]);
          ivs.add(examInfoList[i + 3]);
        }
        yield GetExamsSuccess(
            cardExamInfos: examCards,
            examDetailsList: examDetails,
            fileDownloadURLs: examFileDownloadURLs,
            ivs: ivs);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield ExamProcessingFail();
      }
    } else if (event is DecryptExam) {
      try {
        yield ExamProcessing();

        var fileDownloadURL = event.fileDownloadURL;

        var response = await http.get(fileDownloadURL);
        var bytes = response.body;

        var keyUrl = await this.examRepository.getCryptoKeyDownload();

        var keyResponse = await http.get(keyUrl);
        var base64Key = keyResponse.body;

        var decriptedBytes =
            SltPattern.decryptImageBytes(bytes, event.iv, base64Key);

        yield DecryptExamSuccess(decriptedBytes: decriptedBytes);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield ExamProcessingFail();
      }
    } else if (event is DinamicExamField) {
      try {
        yield DynamicExamFieldProcessing();

        var fieldWidget = ExamDetailsField(
          fieldPlaceholder: event.fieldName,
          fieldValue: event.fieldValue,
          isReadOnly: true,
        );

        yield DynamicExamFieldSuccess(dynamicFieldWidget: fieldWidget);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield DynamicExamFieldFail();
      }
    } else if (event is LoadExamModels) {
      try {
        yield LoadExamModelProcessing();

        var result = await this.examRepository.getExamModels();

        yield LoadExamModelSuccess(models: result);
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield LoadExamModelFail(errorMessage: error.toString());
      }
    }
  }
}
