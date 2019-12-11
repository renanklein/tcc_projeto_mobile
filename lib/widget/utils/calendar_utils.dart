import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/tiles/calendar_event_tile.dart';

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
      List _selectedDayDescriptions, DateTime _selectedDay) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      shrinkWrap: true,
      children: _selectedDayDescriptions.map((event) {
        return ListTile(
         title: CalendarEventTile(
         eventText: event, 
         eventDate: _selectedDay),
        );
      }).toList(),
    );
  }
}
