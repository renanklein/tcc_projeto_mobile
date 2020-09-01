import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamDetailsScreen extends StatefulWidget {
  final examDetails;
  final examBloc;
  final filePath;

  ExamDetailsScreen(
      {@required this.examDetails,
      @required this.examBloc,
      @required this.filePath});

  @override
  _ExamDetailsScreenState createState() => _ExamDetailsScreenState();
}

class _ExamDetailsScreenState extends State<ExamDetailsScreen> {
  ExamDetails get examDetails => this.widget.examDetails;
  ExamBloc get examBloc => this.widget.examBloc;
  String get filePath => this.widget.filePath;
  bool isDecripted = false;
  Image examImage;

  @override
  void initState() {
    this.examBloc.add(DecriptExam(filePath: this.filePath));
    super.initState();
  }

  @override
  void dispose() {
    this.examBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do Exame"),
          centerTitle: true,
        ),
        body: BlocListener<ExamBloc, ExamState>(
          cubit: this.examBloc,
          listener: (context, state) {
            if (state is DecriptExamSuccess) {
              this.examImage = Image.memory(state.decriptedBytes);
              this.isDecripted = true;
            } else if (state is ExamProcessingFail) {
              onFail("Erro ao exibir detalhes do exame");
            }
          },
          child: BlocBuilder<ExamBloc, ExamState>(
            cubit: this.examBloc,
            builder: (context, state) {
              if (state is ExamProcessing) {
                return LayoutUtils.buildCircularProgressIndicator(context);
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(children: _buildExamDetails()),
              );
            },
          ),
        ));
  }

  InputDecoration _buildFieldDecoration(String fieldValue) {
    return InputDecoration(
      hintText: fieldValue,
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    );
  }

  List<Widget> _buildExamDetails() {
    return <Widget>[
      LayoutUtils.buildVerticalSpacing(20.0),
      this.isDecripted ? _buildExameImageWidget() : Container(),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Nome do paciente: ${this.examDetails.getPacientName}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Decrição do exame: ${this.examDetails.getExamDescription}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          decoration: _buildFieldDecoration(
              "Data do exam: ${this.examDetails.getExamDate}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Responsável pelo exame: ${this.examDetails.getExamResponsable}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Hipótese diagnóstica: ${this.examDetails.getDiagnosticHypothesis}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Unidade de realização do exame: ${this.examDetails.getExaminationUnit}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Outras informações do paciente: ${this.examDetails.getOtherPacientInformation}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Médico solicitante: ${this.examDetails.getRequestingDoctor}")),
      LayoutUtils.buildVerticalSpacing(20.0),
    ];
  }

  void onFail(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    ));
  }

  Widget _buildExameImageWidget() {
    return Container(child: this.examImage);
  }
}
