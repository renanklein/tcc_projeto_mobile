import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/bloc/agenda_bloc.dart';
import 'package:tcc_projeto_app/repository/agenda_repository.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/ui/screens/event_editor_screen.dart';

import 'elements/events/event_avatar.dart';
import 'elements/events/event_description.dart';

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
          "id" : this.eventId,
          "description" : this.eventText,
          "begin" : this.eventHourStart,
          "end" : this.eventHourEnd
        };
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventEditorScreen(
                  event: event,
                  isEdit: true,
                  selectedDay: this.selectedDay,
                  agendaRepository: this.agendaRepository,
        )));
      },

      onLongPress: (){
        var agendaBloc = new AgendaBloc(agendaRepository:  Injector.appInstance.getDependency<AgendaRepository>());

        agendaBloc.add(AgendaDeleteButtonPressed(
          eventDay: this.selectedDay,
          eventId: this.eventId
        ));

        agendaBloc.close();
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
