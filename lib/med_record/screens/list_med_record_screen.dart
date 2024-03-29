import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/exams/screens/exam_screen.dart';
import 'package:tcc_projeto_app/exams/screens/exam_solicitation_form_screen.dart';
import 'package:tcc_projeto_app/exams/screens/exam_solicitation_screen.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/med_record/style/med_record_style.dart';
import 'package:tcc_projeto_app/med_record/tile/overview_tile.dart';
import 'package:tcc_projeto_app/exams/screens/exam_form_screen.dart';
import 'package:tcc_projeto_app/med_record/screens/list_diagnosis_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/pacient_detail_screen.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';

class MedRecordScreen extends StatefulWidget {
  final MedRecordArguments medRecordArguments;

  MedRecordScreen({
    @required this.medRecordArguments,
  });

  @override
  _MedRecordScreenState createState() => _MedRecordScreenState();
}

class _MedRecordScreenState extends State<MedRecordScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;
  String _pacientHash;

  MedRecordArguments get medRecordArguments => this.widget.medRecordArguments;

  int _selectedIndex;

  final userRepository = Injector.appInstance.get<UserRepository>();
  @override
  void initState() {
    this._pacientHash = _hasPacientHashArguments()
        ? null
        : SltPattern.retrivepacientHash(
            this.medRecordArguments.pacientModel.getCpf,
            this.medRecordArguments.pacientModel.getSalt);
    var injector = Injector.appInstance;
    this._medRecordRepository = injector.get<MedRecordRepository>();
    var examRepository = injector.get<ExamRepository>();
    this._medRecordBloc = new MedRecordBloc(
        medRecordRepository: this._medRecordRepository,
        examRepository: examRepository);

    if (medRecordArguments.index != null) {
      _selectedIndex = _parseIndex(medRecordArguments.index);
    } else {
      _selectedIndex = 1;
    }

    if (medRecordArguments.pacientModel.getCpf != null &&
        medRecordArguments.pacientModel.getSalt != null) {
      _medRecordBloc.add(
        MedRecordLoad(
          pacientCpf: medRecordArguments.pacientModel.getCpf,
          pacientSalt: medRecordArguments.pacientModel.getSalt,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Prontuário Médico"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: BlocListener<MedRecordBloc, MedRecordState>(
          bloc: this._medRecordBloc,
          listener: (context, state) {
            if (state is AuthenticationUnauthenticated) {
            } else if (state is MedRecordLoadEventSuccess) {}
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            bloc: this._medRecordBloc,
            builder: (context, state) {
              if (state is CreateMedRecordEventProcessing) {
                return LayoutUtils.buildCircularProgressIndicator(context);
              } else {
                return SafeArea(
                  child: Row(
                    children: <Widget>[
                      LayoutBuilder(
                        builder: (context, constraint) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraint.maxHeight),
                              child: IntrinsicHeight(
                                child: NavigationRail(
                                  selectedIndex: _selectedIndex,
                                  onDestinationSelected: (int index) {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  labelType: NavigationRailLabelType.selected,
                                  destinations: [
                                    NavigationRailDestination(
                                      icon: Icon(Icons.add_circle),
                                      label: Text('Novo'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.portrait),
                                      label: Text('Resumo'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.content_paste),
                                      label: Text('Exames'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.question_answer),
                                      label: Text('Solicitações'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.healing),
                                      label: Text('Diagnóstico'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.file_upload),
                                      label: Text('Third'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.add_to_photos),
                                      label: Text('Third'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.child_friendly),
                                      label: Text('Ficha RN'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.apps),
                                      label: Text('Third'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.close),
                                      label: Text('Third'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.compare),
                                      //selectedIcon: Icon(Icons.star),
                                      label: Text('Third'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      VerticalDivider(thickness: 1, width: 1),
                      // This is the main content.
                      Expanded(
                        child: _showMedRecord(_selectedIndex, context),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }

  Widget _showMedRecord(index, context) {
    switch (index) {
      case 1:
        return ListView(
          shrinkWrap: true,
          children: [
            OverviewTile(
              pacientCpf: this.medRecordArguments.pacientModel.getCpf,
              pacientSalt: this.medRecordArguments.pacientModel.getSalt,
            ),
            PacientDetailScreen(
              pacient: medRecordArguments.pacientModel,
            ),
            LayoutUtils.buildVerticalSpacing(10.0),
            ListDiagnosisScreen(
              pacient: this.medRecordArguments.pacientModel,
            ),
            LayoutUtils.buildVerticalSpacing(30.0),
          ],
        );
        break;

      case 2:
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            10.0,
            0.0,
            10.0,
            10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              showPacientName(medRecordArguments),
              MedRecordStyle().breakLine(),
              Flexible(
                  child: ExamScreen(
                pacientHash: this._pacientHash,
              )),
              _buildCreateSolicitationExamButton(),
              LayoutUtils.buildVerticalSpacing(10.0),
              _buildCreateExamButton()
            ],
          ),
        );
        break;

      case 3:
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            15.0,
            10.0,
            15.0,
            10.0,
          ),
          child: ExamSolicitationScreen(
            medRecordArguments: medRecordArguments,
          ),
        );

        break;
      case 4:
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            10.0,
            0.0,
            10.0,
            10.0,
          ),
          child: Column(
            children: [
              showPacientName(medRecordArguments),
              MedRecordStyle().breakLine(),
              Flexible(
                child: ListDiagnosisScreen(
                  pacient: medRecordArguments.pacientModel,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    child: Text(
                      "Cadastrar diagnostico",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    color: Color(0xFF84FFFF),
                    height: 45.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(createDiagnosisRoute,
                              arguments: this.medRecordArguments.pacientModel)
                          .then(
                        (value) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context).pushNamed(medRecordRoute,
                              arguments: MedRecordArguments(
                                  index: "4",
                                  pacientModel:
                                      this.medRecordArguments.pacientModel));
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      default:
        return Text('selectedIndex: $index');
        break;
    }
  }

  _parseIndex(index) {
    switch (index) {
      case 'examScreen':
        return 2;
        break;
      default:
        var parsed = int.tryParse(index);
        if (parsed != null) {
          return parsed;
        }

        return 1;
        break;
    }
  }

  bool _hasPacientHashArguments() {
    return (this.medRecordArguments.pacientModel.getCpf.isEmpty &&
        this.medRecordArguments.pacientModel.getSalt.isEmpty);
  }

  Widget _buildCreateSolicitationExamButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExamSolicitationFormScreen(
                  pacient: this.medRecordArguments.pacientModel,
                )));
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(255.0, 45.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
      child: Text(
        "Criar Solicitação de exame",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCreateExamButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ExamFormScreen(
                      medRecordArguments: this.medRecordArguments,
                      examType: "",
                      examSolicitationId: "",
                    )))
            .then((value) => {
                  this
                      ._medRecordBloc
                      .add(GetExams(pacientHash: this._pacientHash))
                });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(255.0, 45.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
      child: Text(
        "Inserir exame",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

showPacientName(MedRecordArguments args) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Text(
      "Paciente : ${args.pacientModel.getNome}",
      style: TextStyle(fontSize: 16.0),
    ),
  );
}
