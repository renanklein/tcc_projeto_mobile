import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';

class PacientTile extends StatefulWidget {
  final String imgPath;
  final String title;
  final String textBody;
  final String cpf;
  final String salt;

  PacientTile({
    Key key,
    this.title,
    this.textBody,
    this.imgPath,
    this.cpf,
    this.salt,
  }) : super(key: key);

  _PacientTileState createState() => _PacientTileState();
}

class _PacientTileState extends State<PacientTile> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  MedRecordRepository _medRecordRepository;
  bool showOverview = false;

  @override
  void initState() {
    this._pacientRepository = Injector.appInstance.get<PacientRepository>();
    this._medRecordRepository = Injector.appInstance.get<MedRecordRepository>();
    this._pacientBloc = new PacientBloc(
      pacientRepository: _pacientRepository,
      medRecordRepository: _medRecordRepository,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PacientBloc, PacientState>(
      bloc: _pacientBloc,
      listener: (context, state) {
        if (state is ViewPacientOverviewSuccess) {
          setState(() {
            showOverview = true;
          });
        }
      },
      child: BlocBuilder<PacientBloc, PacientState>(
        key: this.widget.key,
        bloc: _pacientBloc,
        builder: (context, state) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Color(0xFF84FFFF),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 3.0, 4.0, 4.0),
                  child: Container(
                    constraints: BoxConstraints.expand(
                      width: 90,
                      height: 90,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                    child: Image.network(this.widget.imgPath),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        this.widget.title,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      GestureDetector(
                        child: (showOverview == true &&
                                state is ViewPacientOverviewSuccess)
                            ? showOverviewCard(
                                state.pacientOverview, showOverview)
                            : showOverviewCard(
                                this.widget.textBody, showOverview),
                        onTap: () {
                          (showOverview == true)
                              ? setState(
                                  () {
                                    showOverview = false;
                                  },
                                )
                              : setState(
                                  () {
                                    _pacientBloc.add(
                                      ViewPacientOverviewButtonPressed(
                                        cpf: this.widget.cpf,
                                        salt: this.widget.salt,
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  showOverviewCard(String texto, bool overview) {
    return Container(
      constraints: BoxConstraints(minHeight: 55.0, minWidth: 250.0),
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: (overview) ? Colors.orange.shade100 : Colors.orangeAccent,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          texto,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
