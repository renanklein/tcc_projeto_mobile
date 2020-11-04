import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:injector/injector.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_dynamic_fields.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamFormScreen extends StatefulWidget {
  final dynamicFieldsList = <Widget>[];
  final medRecordArguments;

  ExamFormScreen({@required this.medRecordArguments});
  @override
  _ExamFormScreenState createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  MedRecordBloc _medRecordBloc;
  TextEditingController _examTypeController = TextEditingController();
  TextEditingController _examDateController = TextEditingController();
  File _examFile;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Widget> get dynamicFieldsList => this.widget.dynamicFieldsList;
  MedRecordArguments get medRecordArguments => this.widget.medRecordArguments;

  @override
  void initState() {
    this._medRecordBloc = MedRecordBloc(
        medRecordRepository:
            Injector.appInstance.getDependency<MedRecordRepository>(),
        examRepository: Injector.appInstance.getDependency<ExamRepository>());
    super.initState();
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
            } else if (state is DynamicExamFieldSuccess) {
              setState(() {
                this.dynamicFieldsList.add(state.dynamicFieldWidget);
              });
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
                      Field(
                          textController: this._examTypeController,
                          fieldPlaceholder: "Tipo de Exame"),
                      LayoutUtils.buildVerticalSpacing(10.0),
                      DateTimeFormField(
                        fieldPlaceholder: "Data de Realização",
                        dateTimeController: this._examDateController,
                      ),
                      LayoutUtils.buildVerticalSpacing(10.0),
                      ...this.dynamicFieldsList,
                      RaisedButton(
                        onPressed: () {
                          Scaffold.of(context).showBottomSheet(
                            (context) => ExamDynamicFieldsBottomsheet(
                              dynamicFieldsList: this.dynamicFieldsList,
                              refreshForm: this.refreshFields,
                            ),
                            backgroundColor: Colors.transparent,
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Adicione um campo",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
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
                examDate: this._examDateController.text,
                examType: this._examTypeController.text);

            var examDetails =
                ExamDetails(fieldsWidgetList: this.dynamicFieldsList);

            this._medRecordBloc.add(SaveExam(
                medRecordArguments: this.medRecordArguments,
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

  void refreshFields(List fieldsList, Widget newField) {
    Navigator.of(context).pop();
    setState(() {
      fieldsList.add(newField);
      fieldsList.add(LayoutUtils.buildVerticalSpacing(10.0));
    });
  }
}
