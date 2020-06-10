import 'package:flutter/material.dart';
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

  static Widget buildEventList(
      List _selectedDayDescriptions,
      DateTime _selectedDay,
      AgendaRepository agendaRepository,
      Function refreshAgenda,
      BuildContext context) {
    if (_selectedDayDescriptions == null) {
      return Column();
    }
    List dayEvents = ConvertUtils.toMapListOfEvents(_selectedDayDescriptions);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
          children: dayEvents.map((event) {
        return ListTile(
          title: CalendarEventTile(
            event: event,
            selectedDay: _selectedDay,
            refreshAgenda: refreshAgenda,
          ),
        );
      }).toList()),
    );
  }
}
