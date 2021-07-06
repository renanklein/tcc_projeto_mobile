import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamSolicitationFormScreen extends StatefulWidget {
  const ExamSolicitationFormScreen({Key key}) : super(key: key);

  @override
  _ExamSolicitationFormScreenState createState() =>
      _ExamSolicitationFormScreenState();
}

class _ExamSolicitationFormScreenState
    extends State<ExamSolicitationFormScreen> {
  ExamBloc _examBloc;
  MedRecordBloc _medRecordBloc;
  @override
  void initState() {
    this._examBloc = context.read<ExamBloc>();
    this._medRecordBloc = context.read<MedRecordBloc>();
    this._medRecordBloc.add(LoadExamModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MedRecordBloc, MedRecordState>(
          bloc: this._medRecordBloc,
          listener: (context, state){

        }),
        BlocListener<ExamBloc,ExamState>(
          bloc: this._examBloc,
          listener: (context, state){

        })
      ],
      child: BlocBuilder<MedRecordBloc, MedRecordState>(
        builder: (context, state) {
          if (state is LoadExamModelProcessing) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          }

          return BlocBuilder<ExamBloc, ExamState>(
            builder: (context, state){
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Expanded(child: ListView(
                  children: [],
                )),
              );
            },
          );
        },
      ),
    );
  }

    
}
