import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/home/drawer/screens/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamFormScreen extends StatefulWidget {
  @override
  _ExamFormScreenState createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  ExamBloc _examBloc;
  TextEditingController controller = TextEditingController();
  File examFile;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    this._examBloc = BlocProvider.of<ExamBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    this._examBloc.close();
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
        body: BlocListener<ExamBloc, ExamState>(
          bloc: this._examBloc,
          listener: (context, state) {
            if (state is ExamProcessingSuccess) {
              onSuccess();
              Future.delayed(Duration(seconds: 1));
              Navigator.of(context).pop();
            } else if (state is ExamProcessingFail) {
              onFail("Ocorreu um erro ao tentar salvar o exame");
            }
          },
          child: BlocBuilder<ExamBloc, ExamState>(
              bloc: this._examBloc,
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
                        textController: controller,
                        fieldPlaceholder: "Nome do paciente",
                      ),
                      LayoutUtils.buildVerticalSpacing(20.0),
                      RaisedButton(
                        onPressed: () async {
                          await _setExamFile();
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

  Future _setExamFile() async {
    this.examFile = await FilePicker.getFile(type: FileType.any);
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
          if (this.examFile != null) {
            this._examBloc.add(SaveExam(exam: this.examFile));
          } else {
            onFail("Por favor escolha seu exame");
          }
        },
      ),
    );
  }
}
