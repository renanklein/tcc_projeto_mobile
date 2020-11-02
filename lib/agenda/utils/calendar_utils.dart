import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/tiles/calendar_event_list.dart';
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

// Cor transparente, unica forma de obscurecer os marcadores, lib coloca
// marcadores por default
  static Widget buildEventMarker(DateTime eventDate, List events) {
    return Container(
      decoration:
          BoxDecoration(shape: BoxShape.rectangle, color: Colors.transparent),
      width: 10.0,
      height: 2.0,
    );
  }

  static Widget buildEventList(List _selectedDayDescriptions,
      DateTime _selectedDay, Function refreshAgenda) {
    List dayEvents = ConvertUtils.toMapListOfEvents(_selectedDayDescriptions);

    return CalendarEventList(
      eventsList: dayEvents,
      selectedDay: _selectedDay,
      refreshAgenda: refreshAgenda,
    );
  }
}
