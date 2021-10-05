import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/tiles/calendar_event_list.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

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
  static Widget buildEventMarker(
      DateTime eventDate, List events, bool isSearching, BuildContext context) {
    var agendaRepository = Injector.appInstance.get<AgendaRepository>();
    var dateAsString = DateFormat('yyyy-MM-dd').format(eventDate);
    return FutureBuilder(
        future: agendaRepository.getOccupedDayTimes(dateAsString),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          }

          return _buildEventAvailableCount(snapshot.data);
        });
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

  static Widget _buildEventAvailableCount(List occupedTimes) {
    bool hasEvent = false;
    int totalAvalableTimes = 0;

    var totalTimes = ConvertUtils.getTotalHours();

    totalTimes.forEach((time) {
      if (occupedTimes.contains(time)) {
        hasEvent = true;
      }
      if (hasEvent == false) {
        totalAvalableTimes++;
      }
      hasEvent = false;
    });

    return Container(
      child: Text(
        totalAvalableTimes.toString(),
        style: TextStyle(color: Colors.white, fontSize: 9),
      ),
    );
  }
}
