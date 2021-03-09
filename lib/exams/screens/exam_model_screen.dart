import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_model_card.dart';
import 'package:tcc_projeto_app/exams/screens/exam_model_form.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_model_exclude.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:collection/collection.dart';

class ExamModelsScreen extends StatefulWidget {
  @override
  _ExamModelsScreenState createState() => _ExamModelsScreenState();
}

class _ExamModelsScreenState extends State<ExamModelsScreen> {
  // ignore: close_sinks
  MedRecordBloc _bloc;
  List examModels;
  List<String> examModelTypes = <String>[];
  Map<String, List> examModelFields = Map<String, List>();
  List<Map> _examModelsToBeExcluded = [];
  int toExcludeCardsCount = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    this._bloc = BlocProvider.of<MedRecordBloc>(context);
    this._bloc.add(LoadExamModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        title: Text("Modelos de exame"),
        centerTitle: true,
      ),
      body: BlocListener<MedRecordBloc, MedRecordState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state is LoadExamModelSuccess) {
            state.models == null
                ? this.examModels = null
                : this.examModels = state.models["models"];
            this.toExcludeCardsCount = 0;
          }
        },
        child: BlocBuilder<MedRecordBloc, MedRecordState>(
          cubit: _bloc,
          builder: (context, state) {
            if (state is LoadExamModelProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }
            return ListView(padding: EdgeInsets.all(10.0), children: [
              Center(
                child: Text("Toque nos cards que deseja excluir",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16.0)),
              ),
              LayoutUtils.buildVerticalSpacing(10.0),
              this.toExcludeCardsCount == 0
                  ? Container()
                  : _buildExcludeCardItensBar(),
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
    if (this.examModels != null) {
      this
          .examModels
          .sort((a, b) => a["Tipo de Exame"].compareTo(b["Tipo de Exame"]));
      this.examModels.forEach((map) {
        cards.add(ExamModelCard(
          modelTitle: map["Tipo de Exame"],
          modelFields: map["fields"],
          refreshModels: refreshModels,
          refreshIncludeModelsToExclude: this.refreshIncludeModelToExclude,
          refreshRemoveModelsToExclude: this.refreshRemoveModelToExclude,
        ));
      });

      cards.add(LayoutUtils.buildVerticalSpacing(30.0));

      return cards;
    }

    return <Widget>[
      Center(
        child: Text(
          "Não há modelos de exame cadastrados",
          style:
              TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
        ),
      ),
      LayoutUtils.buildVerticalSpacing(20.0)
    ];
  }

  Widget _buildCreateExamModelButton() {
    return SizedBox(
        height: 30.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            primary: Theme.of(context).primaryColor,
          ),
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

  Widget _buildExcludeCardItensBar() {
    return SizedBox(
      height: 45,
      child: Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "${this.toExcludeCardsCount} modelos selecionados",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                  height: 30.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      primary: Colors.white,
                    ),
                    child: Text(
                      "Excluir modelos",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      this._scaffoldKey.currentState.showBottomSheet(
                          (context) => ExamModelExclude(
                                refreshModels: refreshModels,
                                examModelsToBeExcluded:
                                    this._examModelsToBeExcluded,
                              ),
                          backgroundColor: Colors.transparent);
                    },
                  )),
            ],
          )),
    );
  }

  void refreshModels() {
    setState(() {
      this._bloc.add(LoadExamModels());
    });
  }

  void refreshIncludeModelToExclude(Map examModel) {
    this._examModelsToBeExcluded.add(examModel);
    setState(() {
      this.toExcludeCardsCount++;
    });
  }

  void refreshRemoveModelToExclude(Map examModel) {
    Map toBeRemoved = Map();
    var comparator = DeepCollectionEquality.unordered();
    this._examModelsToBeExcluded.forEach((map) {
      if (comparator.equals(map, examModel)) {
        toBeRemoved = map;
      }
    });
    this._examModelsToBeExcluded.remove(toBeRemoved);
    setState(() {
      this.toExcludeCardsCount--;
    });
  }
}
