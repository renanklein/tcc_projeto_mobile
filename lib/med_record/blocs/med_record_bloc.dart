import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/readonly_text_field.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:encrypt/encrypt.dart';

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

  MedRecordBloc(
      {@required this.medRecordRepository,
      this.examRepository,
      this.pacientRepository})
      : super(null) {
    on<MedRecordCreateButtonPressed>((event, emit) async {
      try {
        emit(CreateMedRecordEventProcessing());

        await medRecordRepository.updateMedRecord(
            pacientHash: event._pacientHash,
            medRecordModel: MedRecordModel(pacientHash: '22'));

        emit(CreateMedRecordEventSuccess());
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(CreateMedRecordEventFail());
      }
    });

    on<MedRecordPacientDetailButtonPressed>((event, emit) async{
      try {
        emit(MedRecordPacientDetailLoading());

        PacientModel _pacientModel;

        _pacientModel =
            await pacientRepository.getPacientByCpf(event._pacientCpf);
        
        emit(MedRecordPacientDetailLoadEventSuccess(pacient: _pacientModel));
      } catch (error) {
        emit(MedRecordPacientDetailLoadEventFailure());
      }
    });

    on<PreDiagnosisCreateOrUpdateButtonPressed>((event, emit) async{
      try {
        emit(MedRecordEventProcessing());
        var dateFormat = DateFormat("dd/MM/yyyy");

        var futures = <Future>[];

        if (event.appointment != null &&
            event.appointment.changedDate != null &&
            event.appointment.changedTime != null) {
          futures.add(this.pacientRepository.updateAppointmentDate(
              event.appointment,
              event.appointment.changedDate,
              event.appointment.changedTime));
        }

        var eventDate = event.appointment.changedDate != null
            ? event.appointment.changedDate
            : event.appointment.appointmentDate;

        var preDiagnosis = PreDiagnosisModel(
            peso: event.peso,
            altura: event.altura,
            imc: event.imc,
            paSistolica: event.pASistolica,
            pADiastolica: event.pADiastolica,
            freqCardiaca: event.freqCardiaca,
            freqRepouso: event.freqRepouso,
            temperatura: event?.temperatura,
            glicemia: event?.glicemia,
            observacao: event.obs,
            appointmentEventDate: event.dtAppointmentEvent is DateTime
                ? dateFormat.format(eventDate)
                : event.dtAppointmentEvent,
            dynamicFields: event.dynamicFields,
            createdAt: DateTime.now(),
            dtPreDiagnosis: event.dtPrediagnosis);

        futures.add(this.medRecordRepository.createOrUpdatePacientPreDiagnosis(
            preDiagnosisModel: preDiagnosis,
            date: preDiagnosis.appointmentEventDate));

        await Future.wait(futures);
        emit(PreDiagnosisCreateOrUpdateSuccess(
            preDiagnosisModel: preDiagnosis));
      } catch (error) {
        emit(MedRecordEventFailure());
      }
    });

    on<DiagnosisCreateOrUpdateButtonPressed>((event, emit) async {
      try {
        emit(MedRecordEventProcessing());

        var now = new DateTime.now();
        var dateFormat = DateFormat("dd/MM/yyyy");
        var hoje = dateFormat.format(now);

        var diagnosisModel = CompleteDiagnosisModel(
          id: event.id,
          date: event.isUpdate ? null : now,
          dynamicFields: event.dynamicFields,
          problem: ProblemModel(
              description: event.problemDescription,
              problemId: event.problemId),
          diagnosis: DiagnosisModel(
              descriptionList: event.diagnosisDescription,
              cidList: event.diagnosisCid),
          prescription: event.prescription,
        );

        if (event.isUpdate) {
          await this.medRecordRepository.updatePacientDiagnosis(
              completeDiagnosisModel: diagnosisModel,
              date: event.diagnosisDate);
        } else {
          diagnosisModel.createdAt = now.toLocal();
          await this.medRecordRepository.createPacientDiagnosis(
              completeDiagnosisModel: diagnosisModel, date: hoje);
        }
        emit(DiagnosisCreateOrUpdateSuccess(diagnosisModel: diagnosisModel));
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(MedRecordEventFailure());
      }
    });

    on<OverviewCreateOrUpdateButtonPressed>((event, emit) async{
       try {
        emit(MedRecordEventProcessing());

        await this
            .medRecordRepository
            .setOverviewByHash(event.getPacientHash, event.overview);

        emit(OverviewCreateOrUpdateSuccess(overview: event.overview));
      } catch (error, stack_trace) {
        emit(OverviewCreateOrUpdateFail());
      }
    });

    on<MedRecordLoad>((event, emit) async{
      try {
        emit(MedRecordLoading());

        MedRecordModel medRecord = await this
            .medRecordRepository
            .getMedRecordByHash(event.getPacientHash);

        emit(MedRecordLoadEventSuccess(medRecord: medRecord));
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(MedRecordLoadEventFail());
      }
    });

    on<DiagnosisLoad>((event, emit) async{
      try {
        emit(DiagnosisLoading());

        MedRecordModel medRecord = await this
            .medRecordRepository
            .getMedRecordByHash(event.getPacientHash);

        if (medRecord?.getDiagnosisList == null &&
            medRecord?.getPreDiagnosisList == null) {
          emit(MedRecordLoadEventFail());
        } else {
          emit(DiagnosisLoadEventSuccess(medRecordModel: medRecord));
        }
      } catch (error) {
        emit(MedRecordLoadEventFail());
      }
    });

    on<MedRecordEditButtonPressed>((event, emit) => null);
    on<MedRecordDeleteButtonPressed>((event, emit) => null);

    on<SaveExam>((event, emit) async{
      try {
        emit(ExamProcessing());
        var encriptedFile;
        var randomFileName;
        var keyUrl;

        var mutex = Mutex();
        HttpClient client = new HttpClient()
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
        var ioClient = IOClient(client);
        // For Encrypt/Decrypt purposes
        var initializationVector = IV.fromSecureRandom(16);

        if (event.getExamFile != null) {
          var examBytes = await event.getExamFile.readAsBytes();

          await mutex.acquire();
          try {
            keyUrl = await this.examRepository.getCryptoKeyDownload();
          } finally {
            mutex.release();
          }

          var keyResponse = await ioClient.get(Uri.parse(keyUrl));
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
            event.medRecordArguments.pacientModel.getCpf,
            event.medRecordArguments.pacientModel.getSalt);

        var exams = await this.examRepository.getExam(pacientHash);

        var existsEqualExam = exams.where((element) {
          return element is CardExamInfo &&
              (element.getExamDate == event.cardExamInfo.getExamDate &&
                  element.getExamType == event.cardExamInfo.getExamType);
        }).toList();

        if (existsEqualExam != null && existsEqualExam.isNotEmpty) {
          emit(ExamAlreadyExists());
        } else {
          List<Future> examJobs = <Future>[];

          examJobs.add(this.examRepository.saveExam(
              event.getCardExamInfo,
              event.getExamDetails,
              encriptedFile,
              randomFileName.toString(),
              pacientHash,
              initializationVector,
              event.examSolicitationId,
              diagnosisDate: event.diagnosisDate,
              diagnosisId: event.diagnosisId.toString()));

          if (event.examSolicitationId != null &&
              event.examSolicitationId.isNotEmpty) {
            examJobs.add(this
                .examRepository
                .updateExamSolicitation(pacientHash, event.examSolicitationId));
          }

          await Future.wait(examJobs);
          emit(ExamProcessingSuccess(encriptedFile: encriptedFile));
        }
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(ExamProcessingFail());
      }
    });

    on<GetExams>((event, emit) async{
      try {
        emit(ExamProcessing());

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
        emit(GetExamsSuccess(
            cardExamInfos: examCards,
            examDetailsList: examDetails,
            fileDownloadURLs: examFileDownloadURLs,
            ivs: ivs));
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(ExamProcessingFail());
      }
    });

    on<DecryptExam>((event, emit) async{
      try {
        emit(ExamProcessing());

        var mutex = Mutex();
        var keyUrl;

        var fileDownloadURL = event.fileDownloadURL;
        HttpClient client = new HttpClient()
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
        var ioClient = IOClient(client);

        var response = await ioClient.get(Uri.parse(fileDownloadURL));
        var bytes = response.body;

        await mutex.acquire();

        try {
          keyUrl = await this.examRepository.getCryptoKeyDownload();
        } finally {
          mutex.release();
        }

        var keyResponse = await ioClient.get(Uri.parse(keyUrl));
        var base64Key = keyResponse.body;

        var decriptedBytes =
            SltPattern.decryptImageBytes(bytes, event.iv, base64Key);

        emit(DecryptExamSuccess(decriptedBytes: decriptedBytes));

      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(ExamProcessingFail());
      }
    });

    on<DinamicExamField>((event, emit) async{
       try {
        emit(DynamicExamFieldProcessing());

        var fieldWidget = ReadonlyTextField(
            placeholder: event.fieldName, value: event.fieldValue);

        emit(DynamicExamFieldSuccess(dynamicFieldWidget: fieldWidget));
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(DynamicExamFieldFail());
      }
    });

    on<LoadExamModels>((event, emit) async{
      try {
        emit(LoadExamModelProcessing());

        var result = await this.examRepository.getExamModels();

        emit(LoadExamModelSuccess(models: result));
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(LoadExamModelFail(errorMessage: error.toString()));
      }
    });

    on<GetExamByDiagnosisDateAndId>((event, emit) async{
      try {
        emit(GetExamByDiagnosisDateAndIdProcessing());
        var exam = await this.medRecordRepository.getExameByDiagnosisIdAndDate(
            event.diagnosisDate, event.diagnosisId);
        
        emit(GetExamByDiagnosisDateAndIdSuccess(exam: exam));

      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(GetExamByDiagnosisDateAndIdFail());
      }
    });
  }

  MedRecordState get initialState => MedRecordInicialState();
}
