import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/screens/elements/event_hour.dart';
import 'package:tcc_projeto_app/agenda/screens/elements/event_name.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class EventEditorScreen extends StatefulWidget {
  final event;
  final isEdit;
  final selectedDay;
  final refreshAgenda;

  EventEditorScreen(
      {@required this.event,
      @required this.isEdit,
      @required this.selectedDay,
      @required this.refreshAgenda});

  @override
  _EventEditorScreenState createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends State<EventEditorScreen> {
  AgendaBloc agendaBloc;
  List<String> occupedHours;
  TextEditingController _eventNameController;
  TextEditingController _eventBeginningHourController;
  TextEditingController _eventEndingHourController;
  String eventHour;
  final formKey = new GlobalKey<FormState>();

  Map get event => this.widget.event;
  bool get isEdit => this.widget.isEdit;
  DateTime get selectedDay => this.widget.selectedDay;
  Function get refreshAgenda => this.widget.refreshAgenda;

  @override
  void initState() {
    this.agendaBloc = new AgendaBloc(
        agendaRepository:
            Injector.appInstance.getDependency<AgendaRepository>());
    this._eventNameController = new TextEditingController(
        text: this.event == null ? "" : this.event["description"]);

    this._eventBeginningHourController = new TextEditingController(
        text: this.event == null
            ? ""
            : ConvertUtils.fromTimeOfDay(this.event["begin"]));

    this._eventEndingHourController = new TextEditingController(
        text: this.event == null
            ? ""
            : ConvertUtils.fromTimeOfDay(this.event["end"]));

    this.agendaBloc.add(AgendaEventAvailableTimeLoad(day: this.selectedDay));

    this.eventHour = this.event == null ? null : "${this.event["begin"]} - ${this.event["end"]}";
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
          centerTitle: true,
          title: Text("Agenda"),
          elevation: 0.0,
        ),
        body: BlocProvider<AgendaBloc>(
          create: (context) => this.agendaBloc,
          child: BlocListener<AgendaBloc, AgendaState>(
            listener: (context, state) {
              if (_verifySuccessState(state)) {
                _onSuccessState();
              } else if (_verifyFailState(state)) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Ocorreu um error ao ${this.isEdit ? "editar" : "criar"} o evento",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )));
              } else if (state is AgendaAvailableTimeFail) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Ocorreu um erro ao carregar os horário vagos",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )));
              }
            },
            child: BlocBuilder<AgendaBloc, AgendaState>(
              builder: (context, state) {
                if (_isLoadingState(state)) {
                  return LayoutUtils.buildCircularProgressIndicator(context);
                } else if (state is AgendaAvailableTimeSuccess) {
                  return Form(
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        EventNameField(
                            eventNameController: this._eventNameController),
                        LayoutUtils.buildVerticalSpacing(20.0),

                        EventHourField(
                          occupedHours: state.occupedTimes,
                          eventHour: this.eventHour,
                        ),

                        LayoutUtils.buildVerticalSpacing(20.0),
                        _buildCreateEventButton()
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
  }

  Widget _buildCreateEventButton() {
    return SizedBox(
      height: 44.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: Theme.of(context).primaryColor,
        child: Text(
          "${this.widget.isEdit ? "Editar" : "Criar"}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          _createOrEditEvent();
        },
      ),
    );
  }

  bool _isLoadingState(AgendaState state) {
    return state is AgendaEventProcessing ||
        state is AgendaAvailableTimeLoading;
  }

  void _createOrEditEvent() {
    var eventBeginningHour =
        _retriveTimeAsString(this._eventBeginningHourController.text);
    var eventEndingHour =
        _retriveTimeAsString(this._eventEndingHourController.text);

    var eventStart = TimeOfDay(
        hour: int.parse(eventBeginningHour[0]),
        minute: int.parse(eventBeginningHour[1]));

    var eventEnd = TimeOfDay(
        hour: int.parse(eventEndingHour[0]),
        minute: int.parse(eventEndingHour[1]));

    if (this.widget.isEdit) {
      agendaBloc.add(AgendaEditButtonPressed(
          eventId: this.event["id"].toString(),
          eventDay: this.selectedDay,
          eventName: this._eventNameController.text,
          eventStart: eventStart,
          eventEnd: eventEnd));
    } else {
      agendaBloc.add(AgendaCreateButtonPressed(
          eventDay: this.selectedDay,
          eventName: this._eventNameController.text,
          eventStart: eventStart,
          eventEnd: eventEnd));
    }
  }

  void _onSuccessState() {
    Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
    this.refreshAgenda();
  }

  bool _verifySuccessState(AgendaState state) {
    return state is AgendaEventCreateSuccess || state is AgendaEventEditSuccess;
  }

  bool _verifyFailState(AgendaState state) {
    return state is AgendaEventCreateFail || state is AgendaEventEditFail;
  }

  List<String> _retriveTimeAsString(String time) {
    return time.split(':');
  }
}
