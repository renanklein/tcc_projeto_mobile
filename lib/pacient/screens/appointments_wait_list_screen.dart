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
  List<AppointmentModel> _appointmentList = <AppointmentModel>[];
  List<AppointmentModel> _suggestionAppointments = <AppointmentModel>[];
  TextEditingController _searchBarController = TextEditingController();
  String get userUid => this.widget.userUid;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._pacientBloc = context.read<PacientBloc>();
    _loadAppointments();

    super.initState();
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
      body: BlocListener<PacientBloc, PacientState>(
        bloc: this._pacientBloc,
        listener: (context, state) {
          if (state is AppointmentLoadEventSuccess) {
            this._appointmentList = state.appointmentsLoaded;
            this._appointmentList = _sortAppointments();
          }
        },
        child: BlocBuilder<PacientBloc, PacientState>(
          bloc: this._pacientBloc,
          builder: (context, state) {
            if (state is AppointmentsLoading) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            } else if (this._appointmentList.length == 0 &&
                this._suggestionAppointments.length == 0) {
              return Center(
                child: Text(
                  "Não há atendimentos cadastrados",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return SafeArea(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchBar(
                            placeholder:
                                "Digite o nome do paciente para pesquisar",
                            onChange: onSearchChange,
                            searchBarController: this._searchBarController),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: this._suggestionAppointments.length > 0
                              ? this._suggestionAppointments.length
                              : this._appointmentList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              key: ValueKey<int>(index),
                              width: MediaQuery.of(context).size.width * 0.93,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: ListTile(
                                        title: AppointmentTile(
                                          appointments: this._appointmentList,
                                          loadAppointments: _loadAppointments,
                                          userUid: this.userUid,
                                          appointmentModel: this
                                                      ._suggestionAppointments
                                                      .length >
                                                  0
                                              ? this._suggestionAppointments[
                                                  index]
                                              : this._appointmentList[index],
                                        ),
                                      )),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<AppointmentModel> _sortAppointments() {
    var appointmentsWithPreDiagnosis = <AppointmentModel>[];
    var appointments = this._suggestionAppointments.length > 0
        ? this._suggestionAppointments
        : this._appointmentList;

    appointments.forEach((element) {
      if (element.hasPreDiagnosis) {
        appointmentsWithPreDiagnosis.add(element);
      }
    });

    appointments.removeWhere((element) => element.hasPreDiagnosis);

    appointments.sort((a, b) {
      if (a.appointmentDate.isBefore(b.appointmentDate)) {
        return -1;
      }
      return 1;
    });

    appointmentsWithPreDiagnosis.sort((a, b) {
      if (a.appointmentDate.isBefore(b.appointmentDate)) {
        return -1;
      }
      return 1;
    });

    appointmentsWithPreDiagnosis.forEach((element) {
      appointments.add(element);
    });

    return appointments;
  }

  void _loadAppointments() {
    _pacientBloc.add(AppointmentsLoad());
  }

  void _reorderAppoitments(int oldIndex, int newIndex) {
    var listToReorder = this._suggestionAppointments.length > 0
        ? this._suggestionAppointments
        : this._appointmentList;

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      var appointment = listToReorder.removeAt(oldIndex);
      listToReorder.insert(newIndex, appointment);
    });
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
