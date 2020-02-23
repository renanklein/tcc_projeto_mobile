import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/model/agenda_model.dart';

class EventButtons extends StatefulWidget {
  String eventText;
  String eventDate;
  DateTime eventKey;
  bool isEdit;
  AgendaModel agendaModel;
  EventButtons(
      {@required this.eventText,
      @required this.eventDate,
      @required this.isEdit,
      @required this.agendaModel,
      this.eventKey});
  @override
  _EventButtonsState createState() => _EventButtonsState();
}

class _EventButtonsState extends State<EventButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: () {
              if (this.widget.isEdit) {
                // edit existing event
              } else {
                var test = DateTime.parse(this.widget.eventDate);
                this.widget.agendaModel.addEvent(
                  this.widget.eventText,
                  DateTime.parse(this.widget.eventDate));
              }
              Future.delayed(Duration(seconds: 1));
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
