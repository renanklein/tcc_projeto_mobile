import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/screens/event_editor_screen.dart';
import 'package:tcc_projeto_app/agenda/tiles/elements/event_avatar.dart';
import 'package:tcc_projeto_app/agenda/tiles/elements/event_description.dart';
import 'package:tcc_projeto_app/agenda/tiles/event_exclude_reason.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';




class CalendarEventTile extends StatelessWidget {
  final eventId;
  final eventText;
  final eventHourStart;
  final eventHourEnd;
  final selectedDay;
  final agendaRepository;

  CalendarEventTile(
      {@required this.eventId,
      @required this.eventText,
      @required this.eventHourStart,
      @required this.eventHourEnd,
      @required this.selectedDay,
      @required this.agendaRepository});

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
                eventText: eventText,
                eventHourStart: eventHourStart,
                eventHourEnd: eventHourEnd,
              )
            ]),
      ),
      onTap: () {
        var event = {
          "id": this.eventId,
          "description": this.eventText,
          "begin": this.eventHourStart,
          "end": this.eventHourEnd
        };
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventEditorScreen(
                  event: event,
                  isEdit: true,
                  selectedDay: this.selectedDay,
                  agendaRepository: this.agendaRepository,
                )));
      },
      onLongPress: () {
        showBottomSheet(
            context: context,
            elevation: 2.0,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return EventExcludeBottomSheet(
                eventId: this.eventId,
                eventDay: this.selectedDay,
                agendaRepository:
                    Injector.appInstance.getDependency<AgendaRepository>(),
              );
            });
      },
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0));
  }
}
