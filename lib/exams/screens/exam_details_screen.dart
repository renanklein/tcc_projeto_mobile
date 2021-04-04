import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_details_field.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/readonly_text_field.dart';

class ExamDetailsScreen extends StatefulWidget {
  final examDetails;
  final fileDownloadURL;
  final iv;
  final examDate;
  final examType;

  ExamDetailsScreen(
      {@required this.examDetails,
      @required this.fileDownloadURL,
      @required this.iv,
      @required this.examDate,
      @required this.examType});

  @override
  _ExamDetailsScreenState createState() => _ExamDetailsScreenState();
}

class _ExamDetailsScreenState extends State<ExamDetailsScreen> {
  ExamDetails get examDetails => this.widget.examDetails;
  String get examDate => this.widget.examDate;
  String get exameType => this.widget.examType;

  MedRecordBloc medRecordBloc;
  String get filePath => this.widget.fileDownloadURL;
  String get iv => this.widget.iv;
  bool hidePressed = false;
  bool hideImagePressed = false;
  String hideButtonTitle;
  bool isDecripted = false;
  Image examImage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    this.hideButtonTitle = this.hidePressed ? "Hide" : "Show";
    this.medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    if (this.filePath != null && this.filePath.isNotEmpty) {
      this
          .medRecordBloc
          .add(DecryptExam(fileDownloadURL: this.filePath, iv: this.iv));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Detalhes do Exame"),
          centerTitle: true,
        ),
        body: BlocListener<MedRecordBloc, MedRecordState>(
          cubit: this.medRecordBloc,
          listener: (context, state) {
            if (state is DecryptExamSuccess) {
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

  List<Widget> _buildExamDetails() {
    return <Widget>[
      LayoutUtils.buildVerticalSpacing(20.0),
      this.isDecripted ? _buildExameImageWidget() : Container(),
      LayoutUtils.buildVerticalSpacing(10.0),
      this.examImage == null ? Container() : _showHideImageButton(),
      LayoutUtils.buildVerticalSpacing(10.0),
      ReadonlyTextField(
        value: this.exameType,
        placeholder: "Tipo de exame",
      ),
      LayoutUtils.buildVerticalSpacing(10.0),
      ReadonlyTextField(value: this.examDate, placeholder: "Data do exame"),
      LayoutUtils.buildVerticalSpacing(10.0),
      ...this.examDetails.getFieldsWidgetList
    ];
  }

  void onFail(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
}
