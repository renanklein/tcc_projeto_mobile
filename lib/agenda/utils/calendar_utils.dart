import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/tiles/calendar_event_tile.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';

class CalendarUtils {
  static Widget buildSelectedDayBorder(DateTime date) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      width: 5.0,
      height: 10.0,
      child: Center(
        child: Text(
          "Dia : ${date.toUtc()}",
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16.0),
        ),
      ),
    );
  }

  static Widget buildEventMarker(DateTime eventDate, List events) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
      width: 10.0,
      height: 2.0,
    );
  }

  static List<Widget> buildEventList(
      AgendaBloc agendaBloc,
      List _selectedDayDescriptions,
      DateTime _selectedDay,
      AgendaRepository agendaRepository,
      Function refreshAgenda,
      BuildContext context) {
    if (_selectedDayDescriptions == null) {
      return <Widget>[];
    }
    List dayEvents = ConvertUtils.toMapListOfEvents(_selectedDayDescriptions);

    return dayEvents.map((event) {
      return ListTile(
        title: CalendarEventTile(
          agendaBloc: agendaBloc,
          event: event,
          selectedDay: _selectedDay,
          refreshAgenda: refreshAgenda,
        ),
      );
    }).toList();
  }
}
