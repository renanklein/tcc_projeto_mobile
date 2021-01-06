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
      appBar: AppBar(
        title: Text("Informações do Paciente"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider(
        create: (context) => this._pacientBloc,
        child: BlocListener<PacientBloc, PacientState>(
          listener: (context, state) {},
          child: BlocBuilder(
            cubit: this._pacientBloc,
            builder: (context, state) {
              return SafeArea(child: pacientDetail(getPacient));
            },
          ),
        ),
      ),
    );
  }
}

Widget pacientDetail(PacientModel pacient) {
  return Container(
    child: Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  "Nome: $pacient.nome",
                ),
                Text(
                  "Nome: $pacient.telefone",
                ),
                Text(
                  "Nome: $pacient.email",
                ),
                Text(
                  "Nome: $pacient.rg",
                ),
                Text(
                  "Nome: $pacient.cpf",
                ),
                Text(
                  "Nome: $pacient.dtNascimento",
                ),
                Text(
                  "Nome: $pacient.sexo",
                ),
              ],
            ),
            // TODO: ADD IMAGE
          ],
        ),
      ],
    ),
  );
}
