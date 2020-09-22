import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamDetailsScreen extends StatefulWidget {
  final examDetails;
  final filePath;

  ExamDetailsScreen({
    @required this.examDetails,
    @required this.filePath,
  });

  @override
  _ExamDetailsScreenState createState() => _ExamDetailsScreenState();
}

class _ExamDetailsScreenState extends State<ExamDetailsScreen> {
  ExamDetails get examDetails => this.widget.examDetails;
  MedRecordBloc medRecordBloc;
  String get filePath => this.widget.filePath;
  bool hidePressed = false;
  bool hideImagePressed = false;
  String hideButtonTitle;
  bool isDecripted = false;
  Image examImage;

  @override
  void initState() {
    this.hideButtonTitle = this.hidePressed ? "Hide" : "Show";
    this.medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    this.medRecordBloc.add(DecriptExam(filePath: this.filePath));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do Exame"),
          centerTitle: true,
        ),
        body: BlocListener<MedRecordBloc, MedRecordState>(
          cubit: this.medRecordBloc,
          listener: (context, state) {
            if (state is DecriptExamSuccess) {
              this.examImage = Image.memory(state.decriptedBytes);
              this.isDecripted = true;
            } else if (state is ExamProcessingFail) {
              onFail("Erro ao exibir detalhes do exame");
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            cubit: this.medRecordBloc,
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
      _showHideImageButton(),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          minLines: 1,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Decrição do exame: ${this.examDetails.getExamDescription}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          minLines: 1,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Hipótese diagnóstica: ${this.examDetails.getDiagnosticHypothesis}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          minLines: 1,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Outras informações do paciente: ${this.examDetails.getOtherPacientInformation}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      TextField(
          readOnly: true,
          minLines: 1,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _buildFieldDecoration(
              "Unidade de realização do exame: ${this.examDetails.getExaminationUnit}")),
      LayoutUtils.buildVerticalSpacing(20.0),
      ..._showOtherFields(),
      Visibility(
          visible: true,
          child: IconButton(
            color: Theme.of(context).primaryColor,
            iconSize: 50.0,
            icon: this.hidePressed
                ? Icon(Icons.arrow_drop_up)
                : Icon(Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                this.hidePressed = !this.hidePressed;
              });
            },
          ))
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

  Widget _showHideImageButton() {
    return Visibility(
      visible: true,
      child: IconButton(
          color: Theme.of(context).primaryColor,
          iconSize: 50.0,
          icon: this.hideImagePressed
              ? Icon(Icons.arrow_drop_down)
              : Icon(Icons.arrow_drop_up),
          onPressed: () {
            setState(() {
              this.hideImagePressed = !this.hideImagePressed;
            });
          }),
    );
  }

  Widget _buildExameImageWidget() {
    if (!this.hideImagePressed) {
      return Container(child: this.examImage);
    }

    return Container();
  }

  List<Widget> _showOtherFields() {
    if (this.hidePressed) {
      return <Widget>[
        TextField(
            readOnly: true,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: _buildFieldDecoration(
                "Nome do paciente: ${this.examDetails.getPacientName}")),
        LayoutUtils.buildVerticalSpacing(20.0),
        TextField(
            readOnly: true,
            minLines: 1,
            decoration: _buildFieldDecoration(
                "Data do exam: ${this.examDetails.getExamDate}")),
        LayoutUtils.buildVerticalSpacing(20.0),
        TextField(
            readOnly: true,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: _buildFieldDecoration(
                "Responsável pelo exame: ${this.examDetails.getExamResponsable}")),
        LayoutUtils.buildVerticalSpacing(20.0),
        TextField(
            readOnly: true,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: _buildFieldDecoration(
                "Médico solicitante: ${this.examDetails.getRequestingDoctor}")),
        LayoutUtils.buildVerticalSpacing(20.0),
      ];
    }
    return <Widget>[Container()];
  }
}
