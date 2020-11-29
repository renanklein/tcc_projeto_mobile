import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/pacient/tiles/pacient_tile.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ListPacientScreen extends StatefulWidget {
  @override
  _ListPacientScreenState createState() => _ListPacientScreenState();
}

class _ListPacientScreenState extends State<ListPacientScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  List<PacientModel> _pacientsList;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _searchBarController;

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._pacientRepository = injector.getDependency<PacientRepository>();
    this._pacientBloc =
        new PacientBloc(pacientRepository: this._pacientRepository);

    _loadPacients();

    this._searchBarController = new TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Menu principal"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(createPacientRoute);
            },
          ),
        ),
        body: BlocProvider<PacientBloc>(
            create: (context) => this._pacientBloc,
            child: BlocListener<PacientBloc, PacientState>(
                listener: (context, state) {
                  if (state is PacientLoadEventSuccess) {
                    this._pacientsList = state.pacientsLoaded;
                  } else if (state is PacientLoadEventFail) {}
                },
                child: BlocBuilder<PacientBloc, PacientState>(
                    cubit: this._pacientBloc,
                    builder: (context, state) {
                      if (state is PacientLoading) {
                        return LayoutUtils.buildCircularProgressIndicator(
                            context);
                      }
                      return SafeArea(
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.98,
                                      child: Column(children: <Widget>[
                                        pacientSearchBar(_searchBarController,
                                            'Digite um nome aqui para pesquisar'),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  this._pacientsList?.length,
                                              itemBuilder: (context, index) {
                                                if (this._pacientsList !=
                                                    null) {
                                                 return  _listPacientView(this
                                                      ._pacientsList[index]);
                                                }

                                                return Container();
                                              }),
                                        ),
                                      ])))));
                    }))));
  }

  void _loadPacients() {
    this._pacientBloc.add(PacientLoad());
  }

  Widget _listPacientView(PacientModel pacient) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  medRecordRoute,
                  arguments: MedRecordArguments(
                      index: 'index',
                      pacientCpf: pacient.cpf,
                      pacientSalt: pacient.salt),
                );
              },
              child: PacientTile(
                title: pacient.nome,
                textBody:
                    'Febre Alta, nariz entupido, sem paladar, sem tato, dor no peito, perna inchado, dor nas costas, nervoso, muito chato, ligando, se sentindo perseguido, veio na ultima consulta em 19/09/2019, reclamando de tudo',
                imgPath:
                    'https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget pacientSearchBar(controller, hint) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 4.0),
    child: Container(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          hintText: hint,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    ),
  );
}
