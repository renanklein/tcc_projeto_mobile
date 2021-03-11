import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/pacient/tiles/appointment_tile.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';

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
  PacientModel _pacientModel;
  AppointmentModel _currentAppointment;
  List<AppointmentModel> _appointmentList;
  List<Widget> _appointmentViews;
  String get userUid => this.widget.userUid;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<PacientBloc, PacientState>(
            cubit: this._pacientBloc,
            listener: (context, state) {
              if (state is AppointmentLoadEventSuccess) {
                this._appointmentList = state.appointmentsLoaded;
                while (this._appointmentList.isNotEmpty) {
                  this._currentAppointment = this._appointmentList.first;
                  _loadPacientDetail(this._currentAppointment);
                }
              } else if (state is PacientDetailLoadEventSuccess) {
                this._pacientModel = state.pacientDetailLoaded;
                BlocProvider.of<MedRecordBloc>(context).add(MedRecordLoad(
                    pacientCpf: this._pacientModel.getCpf,
                    pacientSalt: this._pacientModel.getSalt));
                // Navigator.of(context).pushNamed(
                //   preDiagnosisRoute,
                //   arguments: state.pacientDetailLoaded,
                // );
              } else if (state is PacientDetailLoadEventFail) {
                this
                    ._appointmentViews
                    .add(_listAppointmentView(this._currentAppointment));
                this._appointmentList.remove(this._currentAppointment);
                // Navigator.of(context).pushNamed(
                //   createPacientRoute,
                //   arguments: preDiagnosisRoute,
                // );
              }
            },
          ),
          BlocListener<MedRecordBloc, MedRecordState>(
              listener: (context, state) {
            if (state is MedRecordLoadEventSuccess) {
              if (state.medRecordLoaded.getPreDiagnosisList != null &&
                  state.medRecordLoaded.getPreDiagnosisList.isNotEmpty) {
                setPacientAppointmentViews(true);
              } else {
                setPacientAppointmentViews(false);
              }
            }
          })
        ],
        child:
            BlocBuilder<PacientBloc, PacientState>(builder: (context, state) {
          if (this._appointmentList == null ||
              this._appointmentList.isNotEmpty) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          }

          return SafeArea(
              child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.98,
                      child: ListView(
                        children: this._appointmentViews,
                      ))));
        }),
      ),
    );
  }

  Future _loadAppointments() async {
    _pacientBloc.add(AppointmentsLoad());
  }

  Future _loadPacientDetail(AppointmentModel appointment) async {
    _pacientBloc.add(PacientDetailLoad(appointment));
  }

  void setPacientAppointmentViews(bool hasPreDiagnosis) {
    var pacientAppointments = this._appointmentList.where((appointment) =>
        appointment.nome == this._pacientModel.getNome &&
        appointment.telefone == this._pacientModel.getTelefone);

    pacientAppointments.forEach((element) {
      this._appointmentList.remove(element);
    });

    this._appointmentViews.addAll(pacientAppointments.map((appointment) {
      appointment.hasPreDiagnosis = hasPreDiagnosis;

      return _listAppointmentView(appointment);
    }));
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
                //_loadPacientDetail(appointment);
              },
              child: AppointmentTile(
                appointmentModel: appointment,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
