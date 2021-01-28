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
                child: pacientDetail(this.getPacient),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget pacientDetail(PacientModel pacient) {
  return Expanded(
    child: Container(
      child: Row(
        children: <Widget>[
          Column(
            children: [
              Text(
                "Nome: " + pacient.getNome,
              ),
              Text(
                "Telefone: " + pacient.getTelefone,
              ),
              Text(
                "Email: " + pacient.getEmail,
              ),
              Text(
                "Nº Documento: " + pacient.getRg,
              ),
              Text(
                "CPF: " + pacient.getCpf,
              ),
              Text(
                "Data de Nascimento: " + pacient.getDtNascimento,
              ),
              Text(
                "Sexo: " + pacient.getSexo,
              ),
            ],
          ),
          // TODO: ADD IMAGE
        ],
      ),
    ),
  );
}
