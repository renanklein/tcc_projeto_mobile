import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/pacient/tiles/appointment_tile.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class AppointmentsWaitListScreen extends StatefulWidget {
  String userUid;

  AppointmentsWaitListScreen({@required this.userUid});
  @override
  _AppointmentsWaitListScreenState createState() =>
      _AppointmentsWaitListScreenState();
}

class _AppointmentsWaitListScreenState
    extends State<AppointmentsWaitListScreen> {
  PacientBloc _pacientBloc;
  PacientRepository _pacientRepository;
  List<AppointmentModel> _appointmentList;

  String get userUid => this.widget.userUid;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var injector = Injector.appInstance;

    this._pacientRepository = injector.getDependency<PacientRepository>();
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
            } else if (state is PacientDetailLoadEventSuccess) {
              Navigator.of(context).pushNamed(
                preDiagnosisRoute,
                arguments: state.pacientDetailLoaded,
              );
            } else if (state is PacientDetailLoadEventFail) {
              Navigator.of(context).pushNamed(
                createPacientRoute,
                arguments: preDiagnosisRoute,
              );
            }
          },
          child: BlocBuilder<PacientBloc, PacientState>(
              cubit: this._pacientBloc,
              builder: (context, state) {
                return FutureBuilder(
                    future: _loadAppointments(),
                    builder: (context, snapshot) {
                      return SafeArea(
                          child: Center(
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.98,
                                  child: Column(children: <Widget>[
                                    Expanded(
                                        child: (_appointmentList != null)
                                            ? ListView.builder(
                                                itemCount:
                                                    _appointmentList.length,
                                                itemBuilder: (context, index) =>
                                                    _listAppointmentView(
                                                  _appointmentList[index],
                                                ),
                                              )
                                            : LayoutUtils
                                                .buildCircularProgressIndicator(
                                                    context))
                                  ]))));
                    });
              }),
        ),
      ),
    );
  }

  Future _loadAppointments() async {
    await _pacientBloc.add(AppointmentsLoad());
  }

  Future _loadPacientDetail(AppointmentModel appointment) async {
    await _pacientBloc.add(PacientDetailLoad(appointment));
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
                _loadPacientDetail(appointment);
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
