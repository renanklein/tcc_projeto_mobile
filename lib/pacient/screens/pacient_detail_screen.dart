import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';

class PacientDetailScreen extends StatefulWidget {
  PacientModel pacient;

  PacientDetailScreen({@required this.pacient});

  @override
  _PacientDetailScreenState createState() => _PacientDetailScreenState();
}

class _PacientDetailScreenState extends State<PacientDetailScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;

  PacientModel get getPacient => this.widget.pacient;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._pacientRepository = injector.getDependency<PacientRepository>();
    this._pacientBloc =
        new PacientBloc(pacientRepository: this._pacientRepository);

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
      body: BlocProvider<PacientBloc>(
        create: (context) => this._pacientBloc,
        child: BlocListener<PacientBloc, PacientState>(
          listener: (context, state) {},
          child: BlocBuilder(
            cubit: this._pacientBloc,
            builder: (context, state) {
              return SafeArea(
                child: pacientDetail(this.getPacient, context),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget pacientDetail(PacientModel pacient, BuildContext context) {
  return Expanded(
    child: Container(
      child: Row(
        children: <Widget>[
          Column(
            children: [
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
                            'Informações do Paciente',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
              Text(
                "Nome: " + pacient.getNome,
                style: TextStyle(
                              fontSize: 17.0,
                            ),
              ),
              Text(
                "Telefone: " + pacient.getTelefone,style: TextStyle(
                              fontSize: 17.0,
                            ),
              ),
              Text(
                "Email: " + pacient.getEmail,style: TextStyle(
                              fontSize: 17.0,
                            ),
              ),
              Text(
                "Nº Documento: " + pacient.getRg,style: TextStyle(
                              fontSize: 17.0,
                            ),
              ),
              Text(
                "CPF: " + pacient.getCpf,style: TextStyle(
                              fontSize: 17.0,
                            ),
              ),
              Text(
                "Data de Nascimento: " + pacient.getDtNascimento,style: TextStyle(
                              fontSize: 17.0,
                            ),
              ),
              Text(
                "Sexo: " + pacient.getSexo,style: TextStyle(
                              fontSize: 17.0,
                            ),
              ),
            ],
          ),
          // TODO: ADD IMAGE
        ],
      ),
    ),
  );
}
