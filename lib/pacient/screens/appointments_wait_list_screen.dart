import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/pacient/tiles/appointment_tile.dart';
import 'package:tcc_projeto_app/routes/constants.dart';

class AppointmentsWaitListScreen extends StatefulWidget {
  @override
  _AppointmentsWaitListScreenState createState() =>
      _AppointmentsWaitListScreenState();
}

class _AppointmentsWaitListScreenState
    extends State<AppointmentsWaitListScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  List<AppointmentModel> _appointmentList;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._pacientRepository = injector.getDependency<PacientRepository>();
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
        title: Text("Menu principal"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider<PacientBloc>(
        create: (context) => this._pacientBloc,
        child: BlocListener<PacientBloc, PacientState>(
          listener: (context, state) {
            if (state is PacientLoadEventSuccess) {
            } else if (state is PacientLoadEventFail) {}
          },
          child: BlocBuilder<PacientBloc, PacientState>(
              cubit: this._pacientBloc,
              builder: (context, state) {
                return FutureBuilder(
                    future: _loadAppointments(),
                    builder: (context, snapshot) {
                      return SafeArea(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: Column(children: <Widget>[
                                Expanded(
                                  child: (state
                                              is AppointmentLoadEventSuccess &&
                                          state.appointmentsLoaded != null)
                                      ? ListView.builder(
                                          itemCount:
                                              (state.appointmentsLoaded).length,
                                          itemBuilder: (context, index) =>
                                              _listAppointmentView(
                                            state.appointmentsLoaded[index],
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                              Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                )
                              ])));
                    });
              }),
        ),
      ),
    );
  }

  Future _loadAppointments() async {
    await _pacientBloc.add(AppointmentsLoad());
  }

  Widget _listAppointmentView(AppointmentModel appointment) {
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
                );
              },
              child: AppointmentTile(
                nome: appointment.nome,
                telefone: appointment.telefone,
                horarioAgendamento: appointment.appointmentTime,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
