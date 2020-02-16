import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/models/agenda_model.dart';
import 'package:tcc_projeto_app/tiles/elements/form/event_buttons.dart';
import 'package:tcc_projeto_app/tiles/elements/form/event_date.dart';
import 'elements/form/event_name.dart';

class EventEditorTile extends StatefulWidget {
  bool isEdit;
  DateTime eventKey;
  AgendaModel agendaModel;

  //placeholder event list
  EventEditorTile({@required this.isEdit, @required this.agendaModel, this.eventKey});

  @override
  _EventEditorTileState createState() => _EventEditorTileState();
}

class _EventEditorTileState extends State<EventEditorTile> {
  final _eventNameController = TextEditingController();
  final _eventDateController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15.0, right: 15.0, bottom: 30.0),
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            EventNameField(eventNameController: this._eventNameController),
            SizedBox(
              height: 10.0,
            ),
            EventDateField(
              eventDateController: this._eventDateController,
            ),
            SizedBox(
              height: 20.0,
            ),
            EventButtons(
              eventText: _eventNameController.text,
              eventDate: _eventDateController.text,
              agendaModel: this.widget.agendaModel,
              isEdit: this.widget.isEdit,
              eventKey: this.widget.eventKey,
            )
          ],
        ),
      ),
    );
  }
}
