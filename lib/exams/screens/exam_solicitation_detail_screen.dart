import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/screens/exam_details_screen.dart';
import 'package:tcc_projeto_app/exams/screens/exam_form_screen.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamSolicitationDetailScreen extends StatefulWidget {
  final String examSolicitationId;
  final MedRecordArguments medRecordArguments;
  final ExamSolicitationModel examSolicitationModel;
  ExamSolicitationDetailScreen(
      {@required this.examSolicitationId,
      @required this.medRecordArguments,
      @required this.examSolicitationModel});

  @override
  State<StatefulWidget> createState() => _ExamSolicitationDetailScreenState();
}

class _ExamSolicitationDetailScreenState
    extends State<ExamSolicitationDetailScreen> {
  ExamBloc _examBloc;
  Map exam;
  String get examSolicitationId => this.widget.examSolicitationId;
  MedRecordArguments get medRecordArguments => this.widget.medRecordArguments;
  ExamSolicitationModel get examSolicitationModel =>
      this.widget.examSolicitationModel;

  @override
  void initState() {
    var pacientHash = SltPattern.retrivepacientHash(
        this.medRecordArguments.pacientModel.getCpf,
        this.medRecordArguments.pacientModel.getSalt);
    this._examBloc = context.read<ExamBloc>();
    this._examBloc.add(GetExamBySolicitationId(
        examSolicitationId: this.examSolicitationId, pacientHash: pacientHash));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Detalhes da solicitação")),
      body: BlocListener<ExamBloc, ExamState>(
        bloc: this._examBloc,
        listener: (context, state) {
          if (state is GetExamBySolicitationIdSuccess) {
            this.exam = state.exam;
          }
        },
        child: BlocBuilder<ExamBloc, ExamState>(
          bloc: this._examBloc,
          builder: (context, state) {
            if (state is GetExamBySolicitationIdProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Field(
                      textController: TextEditingController(
                          text: this.examSolicitationModel.examTypeModel),
                      fieldPlaceholder: "Tipo de exame:",
                      isReadOnly: true),
                  LayoutUtils.buildVerticalSpacing(10.0),
                  Field(
                      textController: TextEditingController(
                          text: this.examSolicitationModel.solicitationDate),
                      fieldPlaceholder: "Data da solicitação:",
                      isReadOnly: true),
                  LayoutUtils.buildVerticalSpacing(10.0),
                  Field(
                      textController: TextEditingController(
                          text: this.examSolicitationModel.status),
                      fieldPlaceholder: "Status:",
                      isReadOnly: true),
                  LayoutUtils.buildVerticalSpacing(10.0),
                  this.exam != null && this.exam.isNotEmpty
                      ? _buildExamDetailsButton()
                      : Container(),
                  this.examSolicitationModel.status == "solicitado"
                      ? _buildCreateExamButton()
                      : Container()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCreateExamButton() {
    var buttonText = this.examSolicitationModel.status == "solicitado" ? "Cadastrar resultado exame" : "Clique para verificar detalhes";
    
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            primary: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExamFormScreen(
                  medRecordArguments: this.medRecordArguments,
                  examType: this.examSolicitationModel.examTypeModel,
                  examSolicitationId: examSolicitationId)));
        },
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 17.0, color: Colors.white),
        ));
  }

  Widget _buildExamDetailsButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            primary: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExamDetailsScreen(
                  examDetails: ExamDetails.fromMap(this.exam["dynamicFields"]),
                  fileDownloadURL: this.exam["fileDownloadURL"],
                  iv: this.exam["IV"],
                  examDate: this.exam["examDate"],
                  examType: this.exam["examType"])));
        },
        child: Text(
          "Detalhes do exame",
          style: TextStyle(fontSize: 17.0, color: Colors.white),
        ));
  }
}
