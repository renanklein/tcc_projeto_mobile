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

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._medRecordRepository = injector.getDependency<MedRecordRepository>();
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
                        'Não há informações de diagnostico cadastradas para esse paciente'));
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
      Field(
        textController: TextEditingController(text: date),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: 'Text: ' + diagnosisModel.problem.problemDescription),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController:
            TextEditingController(text: diagnosisModel.problem.problemId),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController:
            TextEditingController(text: diagnosisModel.diagnosis.diagnosisCid),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: diagnosisModel.diagnosis.diagnosisDescription),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: diagnosisModel.prescription.prescriptionMedicine),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: diagnosisModel.prescription.prescriptionUsageOrientation),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: diagnosisModel.prescription.prescriptionUsageDuration),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: diagnosisModel.prescription.prescriptionUsageDuration),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: diagnosisModel.prescription.prescriptionDosage),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: diagnosisModel.prescription.prescriptionDosageForm),
        isReadOnly: true,
        fieldPlaceholder: "",
      )
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
      Field(
        textController: TextEditingController(text: date),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: preDiagnosisModel.pASistolica.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: preDiagnosisModel.pADiastolica.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController:
            TextEditingController(text: preDiagnosisModel.peso.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController:
            TextEditingController(text: preDiagnosisModel.imc.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController:
            TextEditingController(text: preDiagnosisModel.glicemia.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: preDiagnosisModel.freqCardiaca.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: preDiagnosisModel.freqRepouso.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
      LayoutUtils.buildVerticalSpacing(8.0),
      showWomanPreDiagnosis,
      LayoutUtils.buildVerticalSpacing(8.0),
      Field(
        textController: TextEditingController(
            text: preDiagnosisModel.observacao.toString()),
        isReadOnly: true,
        fieldPlaceholder: "",
      ),
    ];
  }
}
