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
    this._medRecordBloc = BlocProvider.of<MedRecordBloc>(context);

    _loadDiagnosis();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<MedRecordBloc, MedRecordState>(
        bloc: this._medRecordBloc,
        listener: (context, state) {
          if (state is DiagnosisLoadEventSuccess) {}
        },
        child: BlocBuilder<MedRecordBloc, MedRecordState>(
          bloc: this._medRecordBloc,
          builder: (context, state) {
            if (state is DiagnosisLoading) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            } else if (state is MedRecordLoadEventFail) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    "Não há diagnósticos cadastrados",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
                          ? Column(
                              children: [
                                _listsHeaders("Listar Diagnósticos"),
                                ...listDiagnosisScreen(
                                  state.medRecordLoaded,
                                  context,
                                  pacient,
                                ),
                                _listsHeaders("Listar Pré-diagnósticos"),
                                ...listPreDiagnosisScreen(
                                  state.medRecordLoaded,
                                  pacient,
                                ),
                              ],
                            )
                          : LayoutUtils.buildCircularProgressIndicator(context)
                    ],
                  ));
            }
          },
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
    Navigator.of(context).pop();
    setState(() {
      dynamicFields.add({
        'placeholder': newField.fieldPlaceholder,
        'value': newField.textController.text
      });
    });
  }

  List<Widget> listDiagnosisScreen(
    MedRecordModel medRecordModel,
    BuildContext context,
    PacientModel pacient,
  ) {
    if (medRecordModel.getDiagnosisList == null) return null;

    var createdToday = medRecordModel.getDiagnosisList
        .where((element) => element.createdAt.day == DateTime.now().day)
        .toList();

    medRecordModel.getDiagnosisList
        .removeWhere((element) => element.createdAt.day == DateTime.now().day);

    createdToday.sort((a, b) {
      if (a.createdAt.isBefore(b.createdAt)) {
        return 1;
      }

      return -1;
    });

    medRecordModel.getDiagnosisList.sort((a, b) {
      if (a.diagnosisDate.isBefore(b.diagnosisDate)) {
        return -1;
      }

      return 1;
    });

    medRecordModel.getDiagnosisList.insertAll(0, createdToday);

    var fields = DiagnosisTile.fromDiagnosis(
        medRecordModel.getDiagnosisList, context, refreshDiagnosis, pacient);

    if (fields.isEmpty) {
      return <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                "Não há diagnósticos cadastrados",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ))
      ];
    }

    return fields;
  }

  List<Widget> listPreDiagnosisScreen(
    MedRecordModel medRecordModel,
    PacientModel pacientModel,
  ) {
    if (medRecordModel.getPreDiagnosisList == null) return null;

    var createdToday = medRecordModel.getPreDiagnosisList
        .where(
          (element) => element.createdAt.day == DateTime.now().day,
        )
        .toList();

    medRecordModel.getPreDiagnosisList.removeWhere(
      (element) => element.createdAt.day == DateTime.now().day,
    );

    createdToday.sort(
      (a, b) {
        if (a.createdAt.isBefore(b.createdAt)) {
          return 1;
        }

        return -1;
      },
    );

    medRecordModel.getPreDiagnosisList.sort(
      (a, b) {
        if (a.getPreDiagnosisDate.isBefore(b.getPreDiagnosisDate)) {
          return -1;
        }

        return 1;
      },
    );

    medRecordModel.getPreDiagnosisList.insertAll(0, createdToday);

    var fields = DiagnosisTile.fromPreDiagnosisList(
        medRecordModel.getPreDiagnosisList, refreshDiagnosis, pacientModel);

    if (fields.isEmpty) {
      return <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Não há pré-diagnósticos cadastrados",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ];
    }

    return fields;
  }

  void _loadDiagnosis() {
    this._medRecordBloc.add(
          DiagnosisLoad(
            pacientCpf: this.pacient.getCpf,
            pacientSalt: this.pacient.getSalt,
          ),
        );
  }
}
