import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
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
  List<CompleteDiagnosisModel> _diagnosisList;

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
      appBar: AppBar(
        title: Text("Diagnósticos Cadastrados"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {},
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            cubit: this._medRecordBloc,
            builder: (context, state) {
              return FutureBuilder(
                future: _loadDiagnosis(),
                builder: (context, snapshot) {
                  return SafeArea(
                    child: null,
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
}
