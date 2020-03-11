import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

import 'elements/events/event_avatar.dart';
import 'elements/events/event_description.dart';
import 'event_editor_tile.dart';

class CalendarEventTile extends StatelessWidget {
  final eventText;
  final eventDate;
  final agendaEventBloc;
  CalendarEventTile({@required this.eventText, @required this.eventDate, @required this.agendaEventBloc});

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
            EventDescription(eventText: eventText, eventDate: eventDate)
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
              child: EventEditorTile(
                agendaEventBloc: agendaEventBloc, 
                isEdit: true,
                eventKey: eventDate,
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
