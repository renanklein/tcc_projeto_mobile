import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/tiles/calendar_event_tile.dart';

class UserCalendar extends StatefulWidget {
  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  CalendarController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new CalendarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agenda"),
        elevation: 0.0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: TableCalendar(
          locale: "pt_BR",
          calendarController: _controller,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
              weekdayStyle: TextStyle(color: Colors.grey),
              weekendStyle: TextStyle(color: Colors.grey),
              todayStyle: TextStyle(color: Colors.white)),
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonShowsNext: false,
            titleTextStyle: TextStyle(
              color: Colors.grey,
            ),
            formatButtonTextStyle: TextStyle(
              color: Colors.grey
            )
          ),
          builders: CalendarBuilders(
            
            
           ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayBorder(DateTime date) {
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
          "${date.day}",
          style: TextStyle(
              color: Colors.grey, 
              fontWeight: FontWeight.w400, 
              fontSize: 16.0
          ),
        ),
      ),
    );
  }
}
