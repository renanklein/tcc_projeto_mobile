import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_solicitation_card.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamSolicitationScreen extends StatefulWidget {
  final String pacientHash;

  ExamSolicitationScreen({@required this.pacientHash});
  @override
  State<StatefulWidget> createState() => _ExamSolicitationScreenState();
}

class _ExamSolicitationScreenState extends State<ExamSolicitationScreen> {
  List<ExamSolicitationModel> solicitations = <ExamSolicitationModel>[];
  ExamBloc _examBloc;
  String get pacientHash => this.widget.pacientHash;
  @override
  void initState() {
    this._examBloc = context.read<ExamBloc>();
    this._examBloc.add(GetExamSolicitations(pacientHash: this.pacientHash));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamBloc, ExamState>(
        bloc: this._examBloc,
        listener: (context, state) {
          if (state is GetExamSolicitationsSuccess) {
            this.solicitations = state.solicitations;
          }
        },
        child: BlocBuilder<ExamBloc, ExamState>(
            bloc: this._examBloc,
            builder: (context, state) {
              if (state is GetExamSolicitationsProcessing) {
                return LayoutUtils.buildCircularProgressIndicator(context);
              } else if (this.solicitations.isEmpty) {
                return Center(
                  child: Text(
                    "Não solicitações cadastradas",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 17.0),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: this.solicitations.length,
                  itemBuilder: (context, index) {
                    return ExamSolicitationCard(
                      examSolicitationModel: this.solicitations[index],
                      pacientHash: this.pacientHash,
                    );
                  });
            }));
  }
}
