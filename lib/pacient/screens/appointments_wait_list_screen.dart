import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/pacient/tiles/appointment_tile.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/search_bar.dart';

import '../blocs/pacient_bloc.dart';

class AppointmentsWaitListScreen extends StatefulWidget {
  final String userUid;

  AppointmentsWaitListScreen({
    @required this.userUid,
  });
  @override
  _AppointmentsWaitListScreenState createState() =>
      _AppointmentsWaitListScreenState();
}

class _AppointmentsWaitListScreenState
    extends State<AppointmentsWaitListScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  List<AppointmentModel> _appointmentList;
  List<AppointmentModel> _suggestionAppointments = <AppointmentModel>[];
  TextEditingController _searchBarController = TextEditingController();
  String get userUid => this.widget.userUid;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._pacientRepository = injector.get<PacientRepository>();
    this._pacientRepository.userId = this.userUid;
    this._pacientBloc =
        new PacientBloc(pacientRepository: this._pacientRepository);

    _loadAppointments();

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
      appBar: AppBar(
        title: Text("Atendimentos Futuros"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider<PacientBloc>(
        create: (context) => this._pacientBloc,
        child: BlocListener<PacientBloc, PacientState>(
          listener: (context, state) {
            if (state is AppointmentLoadEventSuccess) {
              _appointmentList = state.appointmentsLoaded;
            }
          },
          child: BlocBuilder<PacientBloc, PacientState>(
            bloc: this._pacientBloc,
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: Column(
                      children: <Widget>[
                        SearchBar(
                            placeholder:
                                "Digite o nome do paciente para pesquisar",
                            onChange: onSearchChange,
                            searchBarController: this._searchBarController),
                        Expanded(
                          child: (_appointmentList != null)
                              ? ListView(
                                children: [
                                  ..._buildSortedAppointmentsViews()
                                ],
                              )
                              : LayoutUtils.buildCircularProgressIndicator(
                                  context),
                        )
                      ],
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

  void _loadAppointments() {
    _pacientBloc.add(AppointmentsLoad());
  }

  AppointmentTile _listAppointmentView(AppointmentModel appointment) {
    return AppointmentTile(
              appointmentModel: appointment,
              userUid: this.userUid,
              loadAppointments: _loadAppointments,
            );
  }

  List<Widget> _buildSortedAppointmentsViews() {
    var listOfWidgets = <AppointmentTile>[];
    var length = _suggestionAppointments.isNotEmpty
        ? _suggestionAppointments.length
        : _appointmentList.length;

    for (int i = 0; i < length; i++) {
      var widget =  _suggestionAppointments.isNotEmpty
          ? _listAppointmentView(_suggestionAppointments[i])
          : _listAppointmentView(_appointmentList[i]);

      listOfWidgets.add(widget);
    }

    listOfWidgets.sort((a, b) => a.sortPriority.compareTo(b.sortPriority));
    Future.delayed(Duration(seconds : 3));
    return listOfWidgets.map((appointment) => Container(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: appointment
          ),
        ],
      ),
    )).toList();
  }

  Widget messageSnackBar(
      context, String message, Color backGroundColor, Color fontColor) {
    return SnackBar(
      backgroundColor: backGroundColor,
      content: Text(
        message,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: fontColor),
      ),
    );
  }

  void onSearchChange(String value) {
    setState(
      () {
        _suggestionAppointments.clear();

        if (value.length > 0) {
          var nome = value.toUpperCase();
          for (final e in _appointmentList) {
            if (e.nome.contains(nome)) {
              _suggestionAppointments.add(e);
            }
          }
          if (_suggestionAppointments.length < 1) {
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
}
