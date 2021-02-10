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

class ListDiagnosisScreen extends StatefulWidget {
  final PacientModel pacient;

  ListDiagnosisScreen({@required this.pacient});

  @override
  _ListDiagnosisScreenState createState() => _ListDiagnosisScreenState();
}

class _ListDiagnosisScreenState extends State<ListDiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;
  MedRecordModel _pacientMedRecord;

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
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {
            if (state is DiagnosisLoadEventSuccess) {
              _pacientMedRecord = state.medRecordLoaded;
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            cubit: this._medRecordBloc,
            builder: (context, state) {
              return FutureBuilder(
                future: _loadDiagnosis(),
                builder: (context, snapshot) {
                  return SafeArea(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                        child: Container(
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
                      ),
                      (state is DiagnosisLoadEventSuccess)
                          ? (state.medRecordLoaded.getDiagnosisList.length > 0)
                              ? ListView.builder(
                                  itemCount:
                                      state.medRecordLoaded.getDiagnosisList.length,
                                  itemBuilder: (context, index) =>
                                      displayDiagnosis(
                                    state.medRecordLoaded.getDiagnosisList[index],
                                  ),
                                )
                              : (state.medRecordLoaded.getPreDiagnosisList.length >
                                      0)
                                  ? ListView.builder(
                                      itemCount: state.medRecordLoaded
                                          .getDiagnosisList.length,
                                      itemBuilder: (context, index) =>
                                          displayDiagnosis(
                                        state.medRecordLoaded
                                            .getDiagnosisList[index],
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                          'Não há informações de diagnostico cadastrado para esse paciente'))
                          : progressIndicator()
                    ]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future _loadDiagnosis() async {
    await _medRecordBloc.add(DiagnosisLoad(
      pacientCpf: this.pacient.getCpf,
      pacientSalt: this.pacient.getSalt,
    ));
  }

  Widget progressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget displayDiagnosis(CompleteDiagnosisModel diagnosisModel) {
    var dateFormat = DateFormat("dd/MM/yyyy");
    var date = dateFormat.format(diagnosisModel.diagnosisDate);

    return Column(
      children: [
        Text(date),
        Text(diagnosisModel.problem.problemDescription),
        Text(diagnosisModel.problem.problemId),
        Text(diagnosisModel.diagnosis.diagnosisCid),
        Text(diagnosisModel.diagnosis.diagnosisDescription),
        Text(diagnosisModel.prescription.prescriptionMedicine),
        Text(diagnosisModel.prescription.prescriptionUsageOrientation),
        Text(diagnosisModel.prescription.prescriptionUsageDuration),
        Text(diagnosisModel.prescription.prescriptionDosage),
        Text(diagnosisModel.prescription.prescriptionDosageForm),
      ],
    );
  }

  Widget displayPreDiagnosis(
      PreDiagnosisModel preDiagnosisModel, PacientModel pacientModel) {
    var dateFormat = DateFormat("dd/MM/yyyy");
    var date = dateFormat.format(preDiagnosisModel.getPreDiagnosisDate);

    Widget showWomanPreDiagnosis = Text('');

    if (pacientModel.getSexo == 'Feminino') {
      showWomanPreDiagnosis = Column(children: [
        Text(preDiagnosisModel.dtProvavelParto.toString()),
        Text(preDiagnosisModel.dtUltimaMestruacao.toString()),
      ]);
    }

    return Column(
      children: [
        Text(date),
        Text(preDiagnosisModel.pASistolica.toString()),
        Text(preDiagnosisModel.pADiastolica.toString()),
        Text(preDiagnosisModel.peso.toString()),
        Text(preDiagnosisModel.imc.toString()),
        Text(preDiagnosisModel.glicemia.toString()),
        Text(preDiagnosisModel.freqCardiaca.toString()),
        Text(preDiagnosisModel.freqRepouso.toString()),
        showWomanPreDiagnosis,
        Text(preDiagnosisModel.observacao.toString()),
      ],
    );
  }
}
