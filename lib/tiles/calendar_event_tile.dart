import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/tiles/elements/events/event_avatar.dart';
import 'package:tcc_projeto_app/tiles/elements/events/event_description.dart';
import 'package:tcc_projeto_app/tiles/event_editor_tile.dart';

class CalendarEventTile extends StatelessWidget {
  String eventText;
  DateTime eventDate;
  CalendarEventTile({@required this.eventText, @required this.eventDate});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        height: 65.0,
        width: 120.0,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
        ),
        duration: Duration(milliseconds: 3000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            EventAvatar(),
            SizedBox(
              width: 15.0,
            ),
            EventDescription(eventText: eventText, eventDate: eventDate)
          ]
        ),
      ),
      onTap: () {
        showBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
          builder: (context){
            return Container(
              height: 250,
              child: EventEditorTile(eventText: this.eventText, eventDate: this.eventDate,),
            );
          }
        );
      },
    );
  }
}
