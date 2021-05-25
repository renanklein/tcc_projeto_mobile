import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/pacient/tiles/pacient_tile.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/dialog_utils/dialog_widgets.dart';
import 'package:tcc_projeto_app/utils/search_bar.dart';

class ListPacientScreen extends StatefulWidget {
  String userUid;

  ListPacientScreen({@required this.userUid});

  @override
  _ListPacientScreenState createState() => _ListPacientScreenState();
}

class _ListPacientScreenState extends State<ListPacientScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  List<PacientModel> pacientsSorted = [];
  List<PacientModel> pacientsList = [];

  String get userUid => this.widget.userUid;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _searchBarController;

  @override
  void initState() {
    this._pacientRepository = Injector.appInstance.get<PacientRepository>();
    this._pacientRepository.userId = this.userUid;
    this._pacientBloc = PacientBloc(pacientRepository: this._pacientRepository);

    this._pacientBloc.add(PacientLoad());

    this._searchBarController = TextEditingController();

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
        title: Text("Listagem de Pacientes"),
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
            Navigator.of(context)
                .pushNamed(createPacientRoute)
                .then((value) => this._pacientBloc.add(PacientLoad()));
          },
        ),
      ),
      body: BlocProvider<PacientBloc>(
        create: (context) => this._pacientBloc,
        child: BlocListener<PacientBloc, PacientState>(
          listener: (context, state) {
            if (state is PacientLoadEventSuccess) {
              pacientsList = state.pacientsLoaded;
            } else if (state is PacientLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<PacientBloc, PacientState>(
            bloc: this._pacientBloc,
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.98,
                      child: Column(
                        children: <Widget>[
                          SearchBar(
                              onChange: onSearchBarChange,
                              placeholder: 'Digite um nome aqui para pesquisar',
                              searchBarController: _searchBarController),
                          Expanded(
                            child: (pacientsList != null)
                                ? _buildPacientView(
                                    pacientsList, pacientsSorted)
                                : Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPacientView(
      List<PacientModel> pacientList, List<PacientModel> sortedList) {
    if (sortedList.length < 1) {
      return ListView.builder(
        itemCount: (pacientList).length,
        itemBuilder: (context, index) => _listPacientView(
          pacientList[index],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: (sortedList).length,
        itemBuilder: (context, index) => _listPacientView(
          sortedList[index],
        ),
      );
    }
  }

  void onSearchBarChange(String value) {
    setState(
      () {
        pacientsSorted.clear();

        if (value.length > 0) {
          var nome = value.toUpperCase();
          for (final e in pacientsList) {
            if (e.getNome.contains(nome)) {
              pacientsSorted.add(e);
            }
          }
          if (pacientsSorted.length < 1) {
            ScaffoldMessenger.of(context).showSnackBar(messageSnackBar(
              context,
              "Paciente não encontrado",
              Colors.red,
              Colors.white,
            ));
            _searchBarController.text = '';
          }
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
    );
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
                    pacientModel: pacient,
                  ),
                );
              },
              child: PacientTile(
                title: pacient.getNome,
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
