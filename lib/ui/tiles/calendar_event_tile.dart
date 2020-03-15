import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/ui/screens/event_editor_screen.dart';

import 'elements/events/event_avatar.dart';
import 'elements/events/event_description.dart';


class CalendarEventTile extends StatelessWidget {
  final eventText;
  final eventHourStart;
  final eventHourEnd;
  final selectedDay;
  final agendaBloc;
  CalendarEventTile({
    @required this.eventText, 
    @required this.eventHourStart,
    @required this.eventHourEnd,
    @required this.selectedDay, 
    @required this.agendaBloc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        height: 65.0,
        width: 120.0,
        decoration:_buildContainerDecoration(),
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
            eventHourEnd: eventHourEnd,)
          ]
        ),
      ),
      onTap: () {
        showBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          builder: (context){
            return Container(
              height: 250,
              child: EventEditorScreen(
                agendaBloc: agendaBloc, 
                isEdit: true,
                selectedDay: selectedDay,
              ) 
            );
          }
        );
      },
    );
  }

  BoxDecoration _buildContainerDecoration(){
    return BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0));
  }
  
}
