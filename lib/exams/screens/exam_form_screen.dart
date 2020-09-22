import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamFormScreen extends StatefulWidget {
  @override
  _ExamFormScreenState createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  MedRecordBloc _medRecordBloc;
  TextEditingController pacientNameController = TextEditingController();
  TextEditingController examDateController = TextEditingController();
  TextEditingController requestingDoctorController = TextEditingController();
  TextEditingController examTypeController = TextEditingController();
  TextEditingController examinationUnitController = TextEditingController();
  TextEditingController examResponsableController = TextEditingController();
  TextEditingController examDescriptionController = TextEditingController();
  TextEditingController diagnosticHypothesisController =
      TextEditingController();
  TextEditingController otherPacientInformation = TextEditingController();
  File _examFile;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    this._medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          title: Text("Salvar exame"),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocListener<MedRecordBloc, MedRecordState>(
          cubit: this._medRecordBloc,
          listener: (context, state) {
            if (state is ExamProcessingSuccess) {
              Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop();
            } else if (state is ExamProcessingFail) {
              onFail("Ocorreu um erro ao tentar salvar o exame");
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
              cubit: this._medRecordBloc,
              builder: (context, state) {
                if (state is ExamProcessing) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      child: ListView(
                    children: [
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: pacientNameController,
                        fieldPlaceholder: "Nome do paciente",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      DateTimeFormField(
                        fieldPlaceholder: "Data de Realização",
                        dateTimeController: examDateController,
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: examTypeController,
                        fieldPlaceholder: "Tipo de exame",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: examinationUnitController,
                        fieldPlaceholder: "Unidade de Realização do Exame",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: requestingDoctorController,
                        fieldPlaceholder: "Médico Solicitante",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: examResponsableController,
                        fieldPlaceholder: "Responsável pelo Exame",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: examDescriptionController,
                        fieldPlaceholder: "Descrição do exame",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: diagnosticHypothesisController,
                        fieldPlaceholder: "Hipótese Diagnóstica",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      Field(
                        textController: otherPacientInformation,
                        fieldPlaceholder: "Outras Informações do paciente",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      RaisedButton(
                        onPressed: () async {
                          _setExamFile();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Escolha o exame",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      _createSubmitButton()
                    ],
                  )),
                );
              }),
        ));
  }

  void onSuccess() {
    this._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Exame salvo com sucesso",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ));
  }

  void onFail(String message) {
    this._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ));
  }

  void _setExamFile() async {
    bool isPermissionGranted = await Permission.storage.request().isGranted;

    if (isPermissionGranted) {
      this._examFile = await FilePicker.getFile();
    }
  }

  Widget _createSubmitButton() {
    return SizedBox(
      height: 44.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: Theme.of(context).primaryColor,
        child: Text(
          "Salvar",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          if (this._examFile != null) {
            var cardExamInfo = CardExamInfo(
                examDate: this.examDateController.text,
                examType: this.examTypeController.text);

            var examDetails = ExamDetails(
                requestingDoctor: this.requestingDoctorController.text,
                examDate: this.examDateController.text,
                pacientName: this.pacientNameController.text,
                diagnosticHypothesis: this.diagnosticHypothesisController.text,
                examDescription: this.examDescriptionController.text,
                examResponsable: this.examResponsableController.text,
                otherPacientInformation: this.otherPacientInformation.text,
                examinationUnit: this.examinationUnitController.text);

            this._medRecordBloc.add(SaveExam(
                examDetails: examDetails,
                examFile: _examFile,
                cardExamInfo: cardExamInfo));
          } else {
            onFail("Por favor escolha seu exame");
          }
        },
      ),
    );
  }
}
