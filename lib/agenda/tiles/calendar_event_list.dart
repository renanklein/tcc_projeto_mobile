import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/screens/event_editor_screen.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class CalendarEventList extends StatefulWidget {
  final eventsList;
  final selectedDay;
  final refreshAgenda;

  CalendarEventList(
      {@required this.eventsList,
      @required this.selectedDay,
      @required this.refreshAgenda});

  @override
  _CalendarEventListState createState() => _CalendarEventListState();
}

class _CalendarEventListState extends State<CalendarEventList> {
  List<Map> get eventsList => this.widget.eventsList;
  DateTime get selectedDay => this.widget.selectedDay;
  Function get refreshAgenda => this.widget.refreshAgenda;

  @override
  Widget build(BuildContext context) {
    String day = "";

    if (this.selectedDay != null) {
      day = DateFormat('yyyy-MM-dd').format(selectedDay);
    }

    AgendaRepository _agendaRepository =
        Injector.appInstance.getDependency<AgendaRepository>();
    return FutureBuilder(
      future: _agendaRepository.getOccupedDayTimes(day),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LayoutUtils.buildCircularProgressIndicator(context);
        }
        return _buildDayTiles(context, snapshot.data);
      },
    );
  }

  Widget _buildTimeTile(String time, bool hasEvent) {
    var event;
    this.eventsList.forEach((el) {
      String eventTime = "${el["begin"]} - ${el["end"]}";
      if (time == eventTime) {
        event = el;
      }
    });
    return ListTile(
      title: GestureDetector(
        child: Text(
          time,
          style: TextStyle(color: hasEvent ? Colors.grey : Colors.white),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => EventEditorScreen(
                        event: hasEvent ? event : null,
                        isEdit: hasEvent,
                        selectedDay: this.widget.selectedDay,
                        refreshAgenda: this.widget.refreshAgenda,
                      )))
              .then((_) => this.widget.refreshAgenda(false));
        },
      ),
    );
  }

  Widget _buildDayTiles(BuildContext context, List<String> occupedTimes) {
    var dayTiles = <Widget>[];
    bool hasEvent;
    var totalTimes = ConvertUtils.getTotalHours();
    totalTimes.forEach((time) {
      hasEvent = false;
      if (occupedTimes.contains(time)) {
        hasEvent = true;
      }

      dayTiles.add(_buildTimeTile(time, hasEvent));
    });

    return ListView(
      children: dayTiles,
    );
  }
}
