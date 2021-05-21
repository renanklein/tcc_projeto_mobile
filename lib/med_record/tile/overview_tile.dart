import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class OverviewTile extends StatefulWidget {
  final String overview;
  final String pacientCpf;
  final String pacientSalt;

  OverviewTile({
    @required this.overview,
    @required this.pacientCpf,
    @required this.pacientSalt,
  });

  @override
  _OverviewTileState createState() => _OverviewTileState();
}

class _OverviewTileState extends State<OverviewTile> {
  MedRecordBloc _medRecordBloc;
  final _overviewFormKey = new GlobalKey<FormState>();
  final _overviewController = TextEditingController();

  String get _pacientCpf => this.widget.pacientCpf;
  String get _pacientSalt => this.widget.pacientSalt;

  @override
  void initState() {
    var _medRepository = Injector.appInstance.get<MedRecordRepository>();
    this._medRecordBloc = MedRecordBloc(medRecordRepository: _medRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedRecordBloc, MedRecordState>(
      listener: (context, state) {},
      child: BlocBuilder<MedRecordBloc, MedRecordState>(
        builder: (context, state) {
          if (state is MedRecordEventProcessing) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          } else {
            return SafeArea(
              child: Form(
                key: _overviewFormKey,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Flexible(
                          child: ListView(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                controller: _overviewController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  labelText: 'Resumo do Paciente',
                                  hintText: 'Descreva a situação do paciente',
                                ),
                                minLines: 1,
                                maxLines: 10,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  color: Color(0xFF84FFFF),
                                  height: 55.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  onPressed: () async {
                                    if (_overviewFormKey.currentState
                                        .validate()) {
                                      _medRecordBloc.add(
                                        OverviewCreateOrUpdateButtonPressed(
                                          pacientCpf: _pacientCpf,
                                          pacientSalt: _pacientSalt,
                                          resumo: _overviewController.text,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Cadastrar Diagnóstico'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
