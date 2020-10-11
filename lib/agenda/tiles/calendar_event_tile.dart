import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/screens/event_editor_screen.dart';
import 'package:tcc_projeto_app/agenda/tiles/elements/event_avatar.dart';
import 'package:tcc_projeto_app/agenda/tiles/elements/event_description.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class CalendarEventTile extends StatelessWidget {
  final event;
  final selectedDay;
  final refreshAgenda;
  final agendaBloc;

  CalendarEventTile(
      {@required this.event,
      @required this.selectedDay,
      @required this.refreshAgenda,
      @required this.agendaBloc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        height: 65.0,
        width: 120.0,
        decoration: _buildContainerDecoration(),
        duration: Duration(milliseconds: 3000),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              EventAvatar(),
              LayoutUtils.buildHorizontalSpacing(15.0),
              EventDescription(
                eventText: this.event["description"],
                eventStatus: this.event["status"],
                eventPhone: this.event["phone"],
                eventHourStart: this.event["begin"],
                eventHourEnd: this.event["end"],
              ),
              ..._buildEventsButtons(context)
            ]),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventEditorScreen(
                  agendaBloc: this.agendaBloc,
                  event: this.event,
                  isEdit: true,
                  selectedDay: this.selectedDay,
                  refreshAgenda: this.refreshAgenda,
                )));
      },
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
        color:
            this.event["status"] == "confirmed" ? Colors.green : Colors.black,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0));
  }

  List<Widget> _buildEventsButtons(BuildContext context) {
    if (this.event["status"] != "confirmed") {
      return <Widget>[
        LayoutUtils.buildHorizontalSpacing(30.0),
        IconButton(
          icon: Icon(
            Icons.check,
            color: Colors.grey,
          ),
          onPressed: () {
            showBottomSheet(
                context: context,
                elevation: 1.0,
                backgroundColor: Theme.of(context).primaryColor,
                builder: (context) {
                  return EventConfirmBottomSheet(
                      event: this.event,
                      eventDay: this.selectedDay,
                      refreshAgenda: this.refreshAgenda);
                });
          },
        ),
        LayoutUtils.buildHorizontalSpacing(3.0),
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.grey,
          ),
          onPressed: () {
            showBottomSheet(
                context: context,
                elevation: 1.0,
                backgroundColor: Theme.of(context).primaryColor,
                builder: (context) {
                  return EventExcludeBottomSheet(
                    eventId: this.event["id"],
                    eventDay: this.selectedDay,
                    refreshAgenda: this.refreshAgenda,
                  );
                });
          },
        )
      ];
    }
    return <Widget>[Container()];
  }
}
