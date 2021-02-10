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
import 'package:tcc_projeto_app/exams/tiles/exam_details_field.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/prescription_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:http/http.dart' as http;

part 'med_record_event.dart';
part 'med_record_state.dart';
part 'diagnosis_state.dart';
part 'diagnosis_event.dart';
part 'pre_diagnosis_state.dart';
part 'pre_diagnosis_event.dart';

class MedRecordBloc extends Bloc<MedRecordEvent, MedRecordState> {
  MedRecordRepository medRecordRepository;
  ExamRepository examRepository;
  PacientRepository pacientRepository;

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
            pacientHash: event._pacientHash,
            medRecordModel: MedRecordModel(pacientHash: '22'));

        yield CreateMedRecordEventSuccess();
      } catch (error) {
        yield CreateMedRecordEventFail();
      }
    } else if (event is MedRecordPacientDetailButtonPressed) {
      try {
        yield MedRecordPacientDetailLoading();

        PacientModel _pacientModel;

        _pacientModel =
            await pacientRepository.getPacientByCpf(event._pacientCpf);

        yield MedRecordPacientDetailLoadEventSuccess(pacient: _pacientModel);
      } catch (error) {
        yield MedRecordPacientDetailLoadEventFailure();
      }
    } else if (event is PreDiagnosisCreateButtonPressed) {
      try {
        yield MedRecordEventProcessing();

        var now = new DateTime.now();
        var dateFormat = DateFormat("dd/MM/yyyy");
        var hoje = dateFormat.format(now);

        await this.medRecordRepository.createPacientPreDiagnosis(
              preDiagnosisModel: PreDiagnosisModel(
                peso: int.parse(event.peso),
                altura: int.parse(event.altura),
                imc: double.parse(event.imc),
                paSistolica: int.parse(event.pASistolica),
                pADiastolica: int.parse(event.pADiastolica),
                freqCardiaca: int.parse(event.freqCardiaca),
                freqRepouso: int.parse(event.freqRepouso),
                temperatura: double.parse(event.temperatura),
                glicemia: int.parse(event.glicemia),
                observacao: event.obs,
                //dtUltimaMestruacao: event.dtUltimaMestruacao,
                //dtProvavelParto: event.dtProvavelParto,
              ),
              date: hoje,
            );

        yield MedRecordEventSuccess();
      } catch (error) {
        yield MedRecordEventFailure();
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
            .getMedRecordByHash(event.getPacientHash);

        yield MedRecordLoadEventSuccess(medRecord: medRecord);
      } catch (error) {
        yield MedRecordLoadEventFail();
      }
    } else if (event is DiagnosisLoad) {
      try {
        yield DiagnosisLoading();

        MedRecordModel medRecord = await this
            .medRecordRepository
            .getMedRecordByHash(event.getPacientHash);

        if (medRecord.getDiagnosisList.length < 1 && medRecord.getPreDiagnosisList.length < 1) {
          yield MedRecordLoadEventFail();
          } 
            yield DiagnosisLoadEventSuccess(medRecordModel: medRecord);
           
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
        var tempDir = await getTemporaryDirectory();
        var tempPath = tempDir.path;
        var randomFileName = Random.secure().nextInt(10000);
        var fileName = randomFileName.toString();
        var encriptedFile = File("$tempPath/$fileName");
        await encriptedFile.writeAsString(encoded);

        var pacientHash = SltPattern.retrivepacientHash(
            event.medRecordArguments.pacientModel.getCpf,
            event.medRecordArguments.pacientModel.getSalt);

        await this.examRepository.saveExam(
            event.getCardExamInfo,
            event.getExamDetails,
            encriptedFile,
            randomFileName.toString(),
            pacientHash);

        yield ExamProcessingSuccess(encriptedFile: encriptedFile);
      } catch (error) {
        yield ExamProcessingFail();
      }
    } else if (event is GetExams) {
      try {
        yield ExamProcessing();

        var examInfoList = await this.examRepository.getExam(event.pacientHash);

        List examCards = [];
        List examDetails = [];
        List examFileDownloadURLs = [];

        for (int i = 0; i < examInfoList.length; i += 3) {
          examCards.add(examInfoList[i]);
          examDetails.add(examInfoList[i + 1]);
          examFileDownloadURLs.add(examInfoList[i + 2]);
        }
        yield GetExamsSuccess(
            cardExamInfos: examCards,
            examDetailsList: examDetails,
            fileDownloadURLs: examFileDownloadURLs);
      } catch (error) {
        yield ExamProcessingFail();
      }
    } else if (event is DecriptExam) {
      try {
        yield ExamProcessing();

        var fileDownloadURL = event.fileDownloadURL;

        var response = await http.get(fileDownloadURL);
        var bytes = response.body;
        var decriptedBytes = base64.decode(bytes);

        yield DecriptExamSuccess(decriptedBytes: decriptedBytes);
      } catch (error) {
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
      } catch (e) {
        yield DynamicExamFieldFail();
      }
    } else if (event is LoadExamModels) {
      try {
        yield LoadExamModelProcessing();

        var result = await this.examRepository.getExamModels();

        yield LoadExamModelSuccess(models: result);
      } catch (error) {
        yield LoadExamModelFail(errorMessage: error.toString());
      }
    }
  }
}
