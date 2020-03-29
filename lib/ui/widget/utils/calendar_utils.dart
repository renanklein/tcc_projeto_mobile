import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/ui/tiles/calendar_event_tile.dart';
import 'package:tcc_projeto_app/bloc/agenda_bloc.dart';
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

  static Widget buildEventList(List _selectedDayDescriptions,
      DateTime _selectedDay) {
    if (_selectedDayDescriptions == null) {
      return Column();
    }
    List dayEvents = ConvertUtils.toMapListOfEvents(_selectedDayDescriptions);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
          children: dayEvents.map((event) {
        var eventId = event["id"];
        var beginHourSplited = event["begin"].split(":");
        var endHourSplited = event["end"].split(":");
        var description = event["description"];

        return ListTile(
          title: CalendarEventTile(
            eventId: eventId,
            eventText: description,
            selectedDay: _selectedDay,
            eventHourStart: TimeOfDay(
                hour: int.parse(beginHourSplited[0]), minute: int.parse(beginHourSplited[1])),
            eventHourEnd:
                TimeOfDay(hour: int.parse(endHourSplited[0]), minute: int.parse(endHourSplited[1]))
          ),
        );
      }).toList()),
    );
  }
}
