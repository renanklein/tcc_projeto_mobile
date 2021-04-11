import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/med_record/tile/diagnosis_tile.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ListDiagnosisScreen extends StatefulWidget {
  final PacientModel pacient;

  ListDiagnosisScreen({@required this.pacient});

  @override
  _ListDiagnosisScreenState createState() => _ListDiagnosisScreenState();
}

class _ListDiagnosisScreenState extends State<ListDiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;

  bool showBothDiagnosis = false;

  PacientModel get pacient => this.widget.pacient;

  //final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._medRecordRepository = injector.get<MedRecordRepository>();
    this._medRecordBloc =
        new MedRecordBloc(medRecordRepository: _medRecordRepository);

    _loadDiagnosis();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {
            if (state is DiagnosisLoadEventSuccess) {}
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            cubit: this._medRecordBloc,
            builder: (context, state) {
              if (state is DiagnosisLoading) {
                return LayoutUtils.buildCircularProgressIndicator(context);
              } else if (state is MedRecordLoadEventFail) {
                return Center(
                  child: Text(
                      'Não há informações de diagnostico cadastradas para esse paciente'),
                );
              } else {
                return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        LayoutUtils.buildVerticalSpacing(10.0),
                        (state is DiagnosisLoadEventSuccess)
                            ? Column(children: [
                                _listsHeaders("Listar Diagnósticos"),
                                ...listDiagnosisScreen(
                                    state.medRecordLoaded, context),
                                _listsHeaders("Listar Pré-diagnósticos"),
                                ...listPreDiagnosisScreen(
                                    state.medRecordLoaded, pacient)
                              ])
                            : LayoutUtils.buildCircularProgressIndicator(
                                context)
                      ],
                    ));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _listsHeaders(String title) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ));
  }

  void refreshDiagnosis(List dynamicFields, Field newField) {
    setState(() {
      dynamicFields.add({
        'placeholder': newField.fieldPlaceholder,
        'value': newField.textController.text
      });
    });
  }

  List<Widget> listDiagnosisScreen(
      MedRecordModel medRecordModel, BuildContext context) {
    if (medRecordModel.getDiagnosisList == null) return null;

    var fields = DiagnosisTile.fromDiagnosis(
        medRecordModel.getDiagnosisList, context, refreshDiagnosis);

    if (fields.isEmpty) {
      return <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                "Não há diagnósticos cadastrados",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
              ),
            ))
      ];
    }

    return DiagnosisTile.fromDiagnosis(
        medRecordModel.getDiagnosisList, context, refreshDiagnosis);
  }

  List<Widget> listPreDiagnosisScreen(
      MedRecordModel medRecordModel, PacientModel pacientModel) {
    if (medRecordModel.getPreDiagnosisList == null) return null;

    var fields = DiagnosisTile.fromPreDiagnosisList(
        medRecordModel.getPreDiagnosisList, refreshDiagnosis);

    if (fields.isEmpty) {
      return <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                "Não há pré-diagnósticos cadastrados",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
              ),
            ))
      ];
    }

    return fields;
  }

  void _loadDiagnosis() {
    _medRecordBloc.add(
      DiagnosisLoad(
        pacientCpf: this.pacient.getCpf,
        pacientSalt: this.pacient.getSalt,
      ),
    );
  }
}
