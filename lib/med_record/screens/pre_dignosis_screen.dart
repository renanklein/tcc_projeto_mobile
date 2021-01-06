import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/exam_event.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';

class PreDiagnosisScreen extends StatefulWidget {
  @override
  _PreDiagnosisScreenState createState() => _PreDiagnosisScreenState();
}

class _PreDiagnosisScreenState extends State<PreDiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;

  final preDiagnosisFormKey = new GlobalKey<FormState>();
  final _preDiagnosisScreenKey = GlobalKey<FormState>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final imcController = TextEditingController();
  final pASistolicaController = TextEditingController();
  final pADiastolicaController = TextEditingController();
  final freqCardiacaController = TextEditingController();
  final freqRepousoController = TextEditingController();
  final temperaturaController = TextEditingController();
  final glicemiaController = TextEditingController();
  final obsController = TextEditingController();

  //apenas para mulheres DUM e DPP
  final ultimaMestruacaoController = TextEditingController();
  final dtProvavelPartoController = TextEditingController();

  @override
  void initState() {
    var injector = Injector.appInstance;
    this._medRecordRepository = injector.getDependency<MedRecordRepository>();

    this._medRecordBloc = new MedRecordBloc(
      medRecordRepository: this._medRecordRepository,
    );

    super.initState();
  }

  @override
  void dispose() {
    pesoController.dispose();
    alturaController.dispose();
    imcController.dispose();
    pASistolicaController.dispose();
    pADiastolicaController.dispose();
    freqCardiacaController.dispose();
    freqRepousoController.dispose();
    temperaturaController.dispose();
    glicemiaController.dispose();
    obsController.dispose();
    ultimaMestruacaoController.dispose();
    dtProvavelPartoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {},
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            builder: (context, state) {
              return SafeArea(
                child: Form(
                  key: _preDiagnosisScreenKey,
                  child: null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
