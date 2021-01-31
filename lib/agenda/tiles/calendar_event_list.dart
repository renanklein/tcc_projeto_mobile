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
  int tableCellCount = 0;

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
    String pacientName = "";
    var event;
    var tableCellCollor = Colors.white;
    this.eventsList.forEach((el) {
      String eventTime = "${el["begin"]} - ${el["end"]}";
      if (time == eventTime) {
        event = el;

        event["status"] == "confirmed"
            ? tableCellCollor = Colors.green[300]
            : tableCellCollor = Colors.grey[400];

        pacientName = event["description"];
      }
    });
    return TableCell(
      child: GestureDetector(
        child: Text(
          "$time      $pacientName",
          style: TextStyle(color: tableCellCollor, fontSize: 15.7),
        ),
        onTap: () {
          var nowDate = DateTime.now();
          var today = DateTime(nowDate.year, nowDate.month, nowDate.day);

          if (this.selectedDay.isAfter(today) ||
              (this.selectedDay.isBefore(today) && event != null)) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EventEditorScreen(
                          event: hasEvent ? event : null,
                          selectedTime: time,
                          isEdit: hasEvent,
                          selectedDay: this.selectedDay,
                          refreshAgenda: this.widget.refreshAgenda,
                        )))
                .then((_) => this.refreshAgenda(false));
          }
        },
      ),
    );
  }

  Widget _buildDayTiles(BuildContext context, List<String> occupedTimes) {
    var hourRows = <TableRow>[];
    var tableRowChildren = <Widget>[];
    bool hasEvent;
    var totalTimes = ConvertUtils.getTotalHours();
    totalTimes.forEach((time) {
      hasEvent = false;
      if (occupedTimes.contains(time)) {
        hasEvent = true;
      }
      this.tableCellCount++;
      tableRowChildren.add(_buildTimeTile(time, hasEvent));

      if (this.tableCellCount % 2 == 0) {
        var lastRowChild = tableRowChildren.last;
        tableRowChildren.removeLast();
        var row = TableRow(
          children: [tableRowChildren.last, lastRowChild],
        );
        tableRowChildren = <Widget>[];
        hourRows.add(row);
      }
    });

    return Table(
      border: TableBorder(
          top: _buildTableBorder(),
          bottom: _buildTableBorder(),
          left: _buildTableBorder(),
          right: _buildTableBorder(),
          horizontalInside: _buildTableBorder(),
          verticalInside: _buildTableBorder()),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: hourRows,
    );
  }

  BorderSide _buildTableBorder() {
    return BorderSide(color: Colors.white, style: BorderStyle.solid);
  }
}
