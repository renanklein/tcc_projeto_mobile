import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/screens/event_editor_screen.dart';
import 'package:tcc_projeto_app/agenda/tiles/elements/event_avatar.dart';
import 'package:tcc_projeto_app/agenda/tiles/elements/event_description.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class CalendarEventTile extends StatelessWidget {
  final event;
  final selectedDay;
  final refreshAgenda;

  CalendarEventTile(
      {@required this.event,
      @required this.selectedDay,
      @required this.refreshAgenda});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        height: 75.0,
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
              )
            ]),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => EventEditorScreen(
                      event: this.event,
                      isEdit: true,
                      selectedDay: this.selectedDay,
                      refreshAgenda: this.refreshAgenda,
                    )))
            .then((_) => this.refreshAgenda(false));
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
}
