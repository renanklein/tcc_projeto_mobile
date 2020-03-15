import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/UI/tiles/elements/form/event_date.dart';
import 'package:tcc_projeto_app/UI/tiles/elements/form/event_name.dart';
import 'package:tcc_projeto_app/bloc/agenda_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class EventEditorScreen extends StatefulWidget {
  final isEdit;
  final agendaBloc;
  final selectedDay;

  EventEditorScreen(
      {@required this.isEdit,
      @required this.agendaBloc,
      @required this.selectedDay});

  @override
  _EventEditorScreenState createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends State<EventEditorScreen> {
  final _eventNameController = TextEditingController();
  final _eventBeginningHourController = TextEditingController();
  final _eventEndingHourController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  bool get isEdit => this.widget.isEdit;
  DateTime get selectedDay => this.widget.selectedDay;
  AgendaBloc get agendaBloc => this.widget.agendaBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agenda"),
        elevation: 0.0,
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            EventNameField(eventNameController: this._eventNameController),
            LayoutUtils.buildVerticalSpacing(20.0),
            EventDateField(
              eventDateController: this._eventBeginningHourController,
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
      ),
    );
  }

  Widget _buildCreateEventButton() {
    return SizedBox(
      height: 44.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
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
    if (this.widget.isEdit) {
      // edit existing event
    } else {
      var eventBeginningHour =
          _retriveTimeAsString(this._eventBeginningHourController.text);
      var eventEndingHour =
          _retriveTimeAsString(this._eventEndingHourController.text);
      agendaBloc.add(AgendaCreateButtonPressed(
          eventDay: this.selectedDay,
          eventName: this._eventNameController.text,
          eventStart: TimeOfDay(
              hour: int.parse(eventBeginningHour[0]),
              minute: int.parse(eventBeginningHour[1])),
          eventEnd: TimeOfDay(
              hour: int.parse(eventEndingHour[0]),
              minute: int.parse(eventEndingHour[1]))));
    }
    Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
  }

  List<String> _retriveTimeAsString(String time) {
    return time.split(':');
  }
}
