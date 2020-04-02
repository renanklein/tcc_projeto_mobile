import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/screens/elements/event_reason.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class EventExcludeBottomSheet extends StatefulWidget {
  final eventDay;
  final eventId;
  final agendaRepository;

  EventExcludeBottomSheet(
      {@required this.eventDay,
      @required this.eventId,
      @required this.agendaRepository});

  @override
  _EventExcludeBottomSheetState createState() => _EventExcludeBottomSheetState();
}

class _EventExcludeBottomSheetState extends State<EventExcludeBottomSheet> {
  final _eventReasonController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  AgendaBloc agendaBloc;

  DateTime get eventDay => this.widget.eventDay;
  String get eventId => this.widget.eventId;
  AgendaRepository get agendaRepository => this.widget.agendaRepository;

  @override
  void initState() {
    this.agendaBloc = new AgendaBloc(agendaRepository: this.agendaRepository);
    super.initState();
  }
  @override
  void dispose() {
    this.agendaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15.0, right: 15.0, bottom: 20.0),
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: EventReason(
                reasonController: this._eventReasonController,
              ),
            ),
            LayoutUtils.buildVerticalSpacing(20.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildCancelButton(),
                _buildExcludeButton()
              ],
            )
          ],
        ),
      ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          "Cancelar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExcludeButton() {
    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.red,
        child: Text(
          "Excluir",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          this.agendaBloc.add(AgendaDeleteButtonPressed(
            eventId: this.eventId,
            eventDay: this.eventDay,
            reason: this._eventReasonController.text
          ));

          Navigator.of(context).pop();
        },
      ),
    );
  }
}
