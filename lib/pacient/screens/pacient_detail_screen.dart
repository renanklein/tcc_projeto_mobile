import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/med_record/style/med_record_style.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';

class PacientDetailScreen extends StatefulWidget {
  PacientModel pacient;

  PacientDetailScreen({@required this.pacient});

  @override
  _PacientDetailScreenState createState() => _PacientDetailScreenState();
}

class _PacientDetailScreenState extends State<PacientDetailScreen> {
  PacientBloc _pacientBloc;
  //PacientRepository _pacientRepository;

  PacientModel get getPacient => this.widget.pacient;

  //final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    this._pacientBloc = context.read<PacientBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<PacientBloc, PacientState>(
        bloc: this._pacientBloc,
        listener: (context, state) {},
        child: BlocBuilder(
          bloc: this._pacientBloc,
          builder: (context, state) {
            return SafeArea(
              child: pacientDetail(this.getPacient, context),
            );
          },
        ),
      ),
    );
  }
}

Widget pacientDetail(PacientModel pacient, BuildContext context) {
  return Container(
    child: Column(
      children: [
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Telefone: " + pacient.getTelefone,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "Email: " + pacient.getEmail,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "Nº Documento: " + pacient.getRg,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "CPF: " + pacient.getCpf,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "Data de Nascimento: " + pacient.getDtNascimento,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "Sexo: " + pacient.getSexo,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
            ),

            // TODO: ADD IMAGE
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
          child: MedRecordStyle().breakLine(),
        ),
      ],
    ),
  );
}
