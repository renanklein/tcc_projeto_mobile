import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_solicitation_card.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';

class ExamSolicitationScreen extends StatefulWidget {
  final MedRecordArguments medRecordArguments;

  ExamSolicitationScreen({@required this.medRecordArguments});
  @override
  State<StatefulWidget> createState() => _ExamSolicitationScreenState();
}

class _ExamSolicitationScreenState extends State<ExamSolicitationScreen> {
  List<ExamSolicitationModel> solicitations = <ExamSolicitationModel>[];
  ExamBloc _examBloc;
  MedRecordArguments get medRecordArguments => this.widget.medRecordArguments;
  @override
  void initState() {
    var pacientHash = SltPattern.retrivepacientHash(
        this.medRecordArguments.pacientModel.getCpf,
        this.medRecordArguments.pacientModel.getSalt);
    this._examBloc = context.read<ExamBloc>();
    this._examBloc.add(GetExamSolicitations(pacientHash: pacientHash));
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

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Text("Clique nos card para exibir os detalhes da solicitação",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.0
                    ),),
                    LayoutUtils.buildVerticalSpacing(15.0),
                    ..._buildExamSolicitationCards()
                  ],
                ),
              );
            }));
  }

  void _sortSolicitationsByDate(){
    this.solicitations.sort((a,b){
      var dateA = ConvertUtils.dateTimeFromString(a.solicitationDate);
      var dateB = ConvertUtils.dateTimeFromString(b.solicitationDate);

      if(dateA.isAfter(dateB)){
        return -1;
      }

      return 1;
    });
  }

  List<Widget> _buildExamSolicitationCards() {
    this._sortSolicitationsByDate();
    var solicitationCards = <Widget>[];

    this.solicitations.forEach((element) {
      solicitationCards.add(ExamSolicitationCard(
        medRecordArguments: this.medRecordArguments,
        examSolicitationModel: element
      ));
      solicitationCards.add(LayoutUtils.buildVerticalSpacing(20.0));
    });


    return solicitationCards;
  }
}
