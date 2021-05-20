import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ConfirmEventsScreen extends StatefulWidget {
  @override
  _ConfirmEventsScreenState createState() => _ConfirmEventsScreenState();
}

class _ConfirmEventsScreenState extends State<ConfirmEventsScreen> {
  AgendaBloc _agendaBloc;
  List _eventsConfirmed = [];
  @override
  void initState() {
    this._agendaBloc = BlocProvider.of<AgendaBloc>(context);
    this._agendaBloc.add(AgendaEventsToBeConfirmed());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agendamentos do dia a confirmar"),
          centerTitle: true,
        ),
        body: BlocListener<AgendaBloc, AgendaState>(
          cubit: this._agendaBloc,
          listener: (context, state) {
            if (state is AgendaEventsToBeConfirmedSuccess) {
              this._eventsConfirmed = state.eventsConfirmed;
            }
          },
          child: BlocBuilder<AgendaBloc, AgendaState>(
            cubit: this._agendaBloc,
            builder: (context, state) {
              if (state is AgendaEventsToBeConfirmedProcessing) {
                return LayoutUtils.buildCircularProgressIndicator(context);
              }

              return ListView(
                children: [
                  Center(
                    child: Text(
                        "Clique no card para editar ou confirmar o agendamento",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0)),
                  ),
                  LayoutUtils.buildVerticalSpacing(10.0),
                  ..._buildEvents(this._eventsConfirmed)
                ],
              );
            },
          ),
        ));
  }

  List<Widget> _buildEvents(List events) {
    var widgets = <Widget>[];
    events.forEach((element) {
      widgets.add(EventToBeConfirmedTile(
          eventTime: "${element['begin']} - ${element['end']}",
          eventDescription: element["description"]));
      widgets.add(LayoutUtils.buildVerticalSpacing(10.0));
    });

    return widgets;
  }
}

class EventToBeConfirmedTile extends StatelessWidget {
  final String eventTime;
  final String eventDescription;
  EventToBeConfirmedTile(
      {@required this.eventTime, @required this.eventDescription});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: Color(0xFF84FFFF),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
              child: Text(
                this.eventTime,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
              child: Text(
                this.eventDescription,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
