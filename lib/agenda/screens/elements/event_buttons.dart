import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/models/agenda_model.dart';

class EventButtons extends StatefulWidget {
  final eventText;
  final eventDate;
  final eventKey;
  final isEdit;
  final agendaModel;
  EventButtons({
    @required this.eventText,
    @required this.eventDate,
    @required this.isEdit,
    @required this.agendaModel,
    this.eventKey,
  });
  @override
  _EventButtonsState createState() => _EventButtonsState();
}

class _EventButtonsState extends State<EventButtons> {
  String get eventText => this.widget.eventText;
  String get eventDate => this.widget.eventDate;
  DateTime get eventKey => this.widget.eventKey;
  bool get isEdit => this.widget.isEdit;
  AgendaModel get agendaModel => this.widget.agendaModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[_buildCancelButton(), _buildEditButton()],
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: RaisedButton(
        color: Colors.grey,
        onPressed: () {
          Navigator.of(context).pop();
        },
        shape: _buildButtonCircularShape(8.0),
        child: Text(
          "Cancelar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: RaisedButton(
        shape: _buildButtonCircularShape(8.0),
        color: Theme.of(context).primaryColor,
        child: Text(
          "${this.isEdit ? "Editar" : "Criar"}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          if (this.isEdit) {
            // edit existing event
          } else {
            this.widget.agendaModel.addEvent(
                this.widget.eventText, DateTime.parse(this.eventDate));
          }
          Future.delayed(Duration(seconds: 1));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  RoundedRectangleBorder _buildButtonCircularShape(double radius) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }
}
