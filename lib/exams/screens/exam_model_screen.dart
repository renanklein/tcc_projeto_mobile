import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_model_card.dart';
import 'package:tcc_projeto_app/exams/screens/exam_model_form.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamModelsScreen extends StatefulWidget {
  @override
  _ExamModelsScreenState createState() => _ExamModelsScreenState();
}

class _ExamModelsScreenState extends State<ExamModelsScreen> {
  // ignore: close_sinks
  MedRecordBloc _bloc;
  dynamic exam_models;
  List<String> examModelTypes = <String>[];
  Map<String, List> examModelFields = Map<String, List>();
  @override
  void initState() {
    this._bloc = BlocProvider.of<MedRecordBloc>(context);
    this._bloc.add(LoadExamModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modelos de exame"),
        centerTitle: true,
      ),
      body: BlocListener<MedRecordBloc, MedRecordState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state is LoadExamModelSuccess) {
            this.exam_models = state.models["models"];
          }
        },
        child: BlocBuilder<MedRecordBloc, MedRecordState>(
          cubit: _bloc,
          builder: (context, state) {
            if (state is LoadExamModelProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }
            return ListView(padding: EdgeInsets.all(10.0), children: [
              ..._buildExamModelCards(),
              _buildCreateExamModelButton()
            ]);
          },
        ),
      ),
    );
  }

  List<Widget> _buildExamModelCards() {
    var cards = <Widget>[];
    if (this.exam_models != null) {
      this.exam_models.forEach((map) {
        cards.add(ExamModelCard(
          modelTitle: map["Tipo de Exame"],
          modelFields: map["fields"],
          refreshModels: refreshModels,
        ));
      });

      cards.add(LayoutUtils.buildVerticalSpacing(30.0));

      return cards;
    }

    return <Widget>[];
  }

  Widget _buildCreateExamModelButton() {
    return SizedBox(
        height: 30.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          color: Theme.of(context).primaryColor,
          child: Text(
            "Criar Modelo",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExamModelForm(
                      isEdit: false,
                      refreshExamModels: refreshModels,
                    )));
          },
        ));
  }

  void refreshModels() {
    setState(() {
      this._bloc.add(LoadExamModels());
    });
  }
}
