import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_solicitation_card.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamSolicitationScreen extends StatefulWidget{
  final String pacientHash;

  ExamSolicitationScreen({@required this.pacientHash});
  @override
  State<StatefulWidget> createState() => _ExamSolicitationScreenState();
}

class _ExamSolicitationScreenState extends State<ExamSolicitationScreen>{
  List<ExamSolicitationModel> solicitations;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Solicitações de exame"),
      ),

      body: BlocListener<ExamBloc, ExamState>(
        bloc: this._examBloc,
        listener: (context, state){
          if(state is GetExamSolicitationsSuccess){
            this.solicitations = state.solicitations;
          }
        },
        child: BlocBuilder<ExamBloc, ExamState>(
          bloc: this._examBloc,
          builder: (context, state){
            if(state is GetExamSolicitationsProcessing){
              return LayoutUtils.buildCircularProgressIndicator(context);
            }

            return ListView.builder(
              itemCount: this.solicitations.length,

              itemBuilder: (context, index){
              return ExamSolicitationCard(
                examSolicitationModel: this.solicitations[index],
              );
            });
          }
        )
      )
    );
  }

}