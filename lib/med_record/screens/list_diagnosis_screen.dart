import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/utils/details_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

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

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Listar Diagnóstico',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        LayoutUtils.buildVerticalSpacing(10.0),
                        (state is DiagnosisLoadEventSuccess)
                            ? Column(children: [
                                ...listDiagnosisScreen(state.medRecordLoaded),
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

  List<Widget> listDiagnosisScreen(MedRecordModel medRecordModel) {
    var fields = <Widget>[];
    if (medRecordModel.getDiagnosisList == null) return null;

    medRecordModel.getDiagnosisList.forEach((element) {
      fields.addAll(displayDiagnosis(element));
    });

    return fields;
  }

  List<Widget> listPreDiagnosisScreen(
      MedRecordModel medRecordModel, PacientModel pacientModel) {
    var fields = <Widget>[];

    if (medRecordModel.getPreDiagnosisList == null) return null;

    medRecordModel.getPreDiagnosisList.forEach((element) {
      fields.addAll(displayPreDiagnosis(element, pacientModel));
    });

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

  List<Widget> displayDiagnosis(CompleteDiagnosisModel diagnosisModel) {
    var dateFormat = DateFormat("dd/MM/yyyy");
    var date = dateFormat.format(diagnosisModel.diagnosisDate);

    return [
      DetailsField(
          fieldValue: date, fieldPlaceholder: "Data", isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.problem.problemDescription,
          fieldPlaceholder: "Descrição do problema",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.problem.problemId,
          fieldPlaceholder: "ID do problema",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.diagnosis.diagnosisCid,
          fieldPlaceholder: "Cid do diagnóstico",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.diagnosis.diagnosisDescription,
          fieldPlaceholder: "Descrição do diagnóstico",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.prescription.prescriptionMedicine,
          fieldPlaceholder: "Medicamento",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.prescription.prescriptionUsageOrientation,
          fieldPlaceholder: "Orientação de uso",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.prescription.prescriptionUsageDuration,
          fieldPlaceholder: "Duração de uso",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.prescription.prescriptionDosage,
          fieldPlaceholder: "Dosagem",
          isReadOnly: true),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
          fieldValue: diagnosisModel.prescription.prescriptionDosageForm,
          fieldPlaceholder: "Formulário de dosagem",
          isReadOnly: true),
    ];
  }

  List<Widget> displayPreDiagnosis(
      PreDiagnosisModel preDiagnosisModel, PacientModel pacientModel) {
    var dateFormat = DateFormat("dd/MM/yyyy");
    var date = dateFormat.format(preDiagnosisModel.getPreDiagnosisDate);

    Widget showWomanPreDiagnosis = Text('');
    String dtProvavelParto = '';
    String dtUltimaMestruacao = '';

    if (preDiagnosisModel.dtProvavelParto != null) {
      dtProvavelParto = dateFormat.format(preDiagnosisModel.dtProvavelParto);
    }

    if (preDiagnosisModel.dtUltimaMestruacao != null) {
      dtUltimaMestruacao =
          dateFormat.format(preDiagnosisModel.dtUltimaMestruacao);
    }

    if (pacientModel.getSexo == 'Feminino' &&
        dtProvavelParto != dtUltimaMestruacao) {
      showWomanPreDiagnosis = Column(children: [
        Text(dtProvavelParto),
        Text(dtUltimaMestruacao),
      ]);
    }

    return [
      DetailsField(
        fieldValue: date,
        isReadOnly: true,
        fieldPlaceholder: "Data",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.pASistolica.toString(),
        isReadOnly: true,
        fieldPlaceholder: "PA Sistolica",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.pADiastolica.toString(),
        isReadOnly: true,
        fieldPlaceholder: "PA Diastolica",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.peso.toString(),
        isReadOnly: true,
        fieldPlaceholder: "Peso",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.imc.toString(),
        isReadOnly: true,
        fieldPlaceholder: "IMC",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.glicemia.toString(),
        isReadOnly: true,
        fieldPlaceholder: "Glicemia",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.freqCardiaca.toString(),
        isReadOnly: true,
        fieldPlaceholder: "Freq Cardíaca",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.freqRepouso.toString(),
        isReadOnly: true,
        fieldPlaceholder: "Freq Repouso",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      showWomanPreDiagnosis,
      LayoutUtils.buildVerticalSpacing(8.0),
      DetailsField(
        fieldValue: preDiagnosisModel.observacao.toString(),
        isReadOnly: true,
        fieldPlaceholder: "Observacao",
      ),
    ];
  }
}
