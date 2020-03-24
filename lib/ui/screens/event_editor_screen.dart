import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/ui/tiles/elements/form/event_date.dart';
import 'package:tcc_projeto_app/ui/tiles/elements/form/event_name.dart';
import 'package:tcc_projeto_app/bloc/agenda_bloc.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class EventEditorScreen extends StatefulWidget {
  final event;
  final isEdit;
  final agendaBloc;
  final selectedDay;

  EventEditorScreen(
      {@required this.event,
      @required this.isEdit,
      @required this.agendaBloc,
      @required this.selectedDay});

  @override
  _EventEditorScreenState createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends State<EventEditorScreen> {
  TextEditingController _eventNameController;
  TextEditingController _eventBeginningHourController;
  TextEditingController _eventEndingHourController;
  final formKey = new GlobalKey<FormState>();

  Map get event => this.widget.event;
  bool get isEdit => this.widget.isEdit;
  DateTime get selectedDay => this.widget.selectedDay;
  AgendaBloc get agendaBloc => this.widget.agendaBloc;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Agenda"),
          elevation: 0.0,
        ),
        body: BlocProvider(
            create: (_) => this.agendaBloc,
            child: BlocListener<AgendaBloc, AgendaState>(
              listener: (context, state) {
                if(_verifySuccessState(state)){
                  Future.delayed(Duration(seconds: 1));
                  Navigator.of(context).pop();
                }
              },
              child: BlocBuilder<AgendaBloc, AgendaState>(
                builder: (context, state) {
                  if (state is AgendaEventProcessing) {
                    return LayoutUtils.buildCircularProgressIndicator(context);
                  }

                  return Form(
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        EventNameField(
                            eventNameController: this._eventNameController),
                        LayoutUtils.buildVerticalSpacing(20.0),
                        EventDateField(
                          eventDateController:
                              this._eventBeginningHourController,
                          eventHint: "Horário de início",
                        ),
                        LayoutUtils.buildVerticalSpacing(20.0),
                        EventDateField(
                          eventDateController: this._eventEndingHourController,
                          eventHint: "Horário de término",
                        ),
                        LayoutUtils.buildVerticalSpacing(20.0),
                        _buildCreateEventButton()
                      ],
                    ),
                  );
                },
              ),
            )));
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

  bool _verifySuccessState(AgendaState state) {
    return state is AgendaEventEditSuccess || state is AgendaEventCreateSuccess;
  }

  List<String> _retriveTimeAsString(String time) {
    return time.split(':');
  }
}
