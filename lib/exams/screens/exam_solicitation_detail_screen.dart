import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/screens/exam_details_screen.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamSolicitationDetailScreen extends StatefulWidget {
  final String examSolicitationId;
  final String pacientHash;
  final ExamSolicitationModel examSolicitationModel;
  ExamSolicitationDetailScreen(
      {@required this.examSolicitationId,
      @required this.pacientHash,
      @required this.examSolicitationModel});

  @override
  State<StatefulWidget> createState() => _ExamSolicitationDetailScreenState();
}

class _ExamSolicitationDetailScreenState
    extends State<ExamSolicitationDetailScreen> {
  ExamBloc _examBloc;
  Map exam;
  String get examSolicitationId => this.widget.examSolicitationId;
  String get pacientHash => this.widget.pacientHash;
  ExamSolicitationModel get examSolicitationModel =>
      this.widget.examSolicitationModel;

  @override
  void initState() {
    this._examBloc = context.read<ExamBloc>();
    this._examBloc.add(GetExamBySolicitationId(
        examSolicitationId: this.examSolicitationId,
        pacientHash: this.pacientHash));

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

            return ListView(
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
                    : Container()
              ],
            );
          },
        ),
      ),
    );
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
                  examDetails: this.exam["dynamicFields"],
                  fileDownloadURL: this.exam["fileDownloadURL"],
                  iv: this.exam["IV"],
                  examDate: this.exam["examDate"],
                  examType: this.exam["examType"])));
        },
        child: Text(
          "Criar Solicitação",
          style: TextStyle(fontSize: 17.0, color: Colors.white),
        ));
  }
}
