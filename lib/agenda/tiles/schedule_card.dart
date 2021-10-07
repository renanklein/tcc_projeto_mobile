import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/screens/event_editor_screen.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ScheduleCard extends StatelessWidget {
  final Map schedule;
  final DateTime scheduleDate;
  final Function refresh;

  ScheduleCard(
      {@required this.schedule,
      @required this.scheduleDate,
      @required this.refresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventEditorScreen(
                event: this.schedule,
                selectedTime:
                    "${this.schedule['begin']} - ${this.schedule['end']}",
                isEdit: true,
                selectedDay: this.scheduleDate,
                refreshAgenda: refresh)));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Card(
            color: Colors.white,
            elevation: 4.0,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: <Widget>[
                LayoutUtils.buildVerticalSpacing(5.0),
                Text(
                  dateFormatter.format(this.scheduleDate),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                LayoutUtils.buildVerticalSpacing(10.0),
                Text(
                  "${this.schedule['begin']} - ${this.schedule['end']}",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                LayoutUtils.buildVerticalSpacing(10.0),
                Text(
                  "${this.schedule['description']}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                LayoutUtils.buildVerticalSpacing(5.0)
              ],
            )),
      ),
    );
  }
}
