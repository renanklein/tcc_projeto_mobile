import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/bloc/agenda_event_bloc.dart';
import 'package:tcc_projeto_app/tiles/elements/form/event_date.dart';
import 'elements/form/event_name.dart';

class EventEditorTile extends StatefulWidget {
  final isEdit;
  final eventKey;
  final agendaEventBloc;
  EventEditorTile(
      {@required this.isEdit, @required this.agendaEventBloc, this.eventKey});

  @override
  _EventEditorTileState createState() => _EventEditorTileState();
}

class _EventEditorTileState extends State<EventEditorTile> {
  final _eventNameController = TextEditingController();
  final _eventDateController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  bool get isEdit => this.widget.isEdit;
  DateTime get eventKey => this.widget.eventKey;
  AgendaEventBloc get agendaEventBloc => this.widget.agendaEventBloc;


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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: RaisedButton(
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "${this.widget.isEdit ? "Editar" : "Criar"}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onPressed: () {
                      if (this.widget.isEdit) {
                        // edit existing event
                      } else {
                        //this._eventNameController.text,
                        //DateTime.parse(this._eventDateController.text)
                        agendaEventBloc.add(AgendaCreateButtonPressed(
                          eventDate: DateTime.parse(this._eventDateController.text),
                          eventName: this._eventNameController.text,
                        ));
                      }
                      Future.delayed(Duration(seconds: 1));
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
