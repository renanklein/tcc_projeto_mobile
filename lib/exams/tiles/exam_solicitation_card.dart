import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/screens/exam_solicitation_detail_screen.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamSolicitationCard extends StatelessWidget {
  final MedRecordArguments medRecordArguments;
  final ExamSolicitationModel examSolicitationModel;

  ExamSolicitationCard(
      {@required this.examSolicitationModel,
      @required this.medRecordArguments});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExamSolicitationDetailScreen(
              medRecordArguments: this.medRecordArguments,
              examSolicitationModel: this.examSolicitationModel,
              examSolicitationId: this.examSolicitationModel.id,
            ),
          ),
        );
      },
      child: Card(
          color: Colors.white,
          elevation: 4.0,
          margin: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  this.examSolicitationModel.examTypeModel,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              LayoutUtils.buildVerticalSpacing(8.0),
              Text(
                this.examSolicitationModel.solicitationDate,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              LayoutUtils.buildVerticalSpacing(8.0),
              Text(
                this.examSolicitationModel.status,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              LayoutUtils.buildVerticalSpacing(8.0)
            ],
          )),
    );
  }
}
