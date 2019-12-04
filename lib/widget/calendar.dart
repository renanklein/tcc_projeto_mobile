import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/widget/utils/calendar_utils.dart';

class UserCalendar extends StatefulWidget {
  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  Map<DateTime, List<String>> _events;
  List _selectedDayDescriptions;
  CalendarController _controller;
  DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    _controller = new CalendarController();
    _selectedDay = DateTime.now();
    _events = {
      _selectedDay.subtract(Duration(days: 0)): [
        "Ir ao mercado",
        "Ir a padaria",
        "Visitar fulano"
      ],
      _selectedDay.add(Duration(days: 2)): ["Lavar a roupa suja"],
      _selectedDay.add(Duration(days: 1)): [
        "Estudar para a prova de matemática"
      ],
      _selectedDay.add(Duration(days: 5)): ["Visitar os avós"],
      _selectedDay.add(Duration(days: 6)): ["Tomar meu remedinho"],
    };
    _selectedDayDescriptions = _events[_selectedDay];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agenda"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
        elevation: 0.0,
      ),
      body: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              TableCalendar(
                locale: "pt_BR",
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedDay = date;
                    _selectedDayDescriptions = events;
                  });
                },
                events: _events,
                calendarController: _controller,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    weekendStyle: TextStyle(color: Colors.white12),
                    todayStyle: TextStyle(color: Colors.white)),
                headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonShowsNext: false,
                    titleTextStyle: TextStyle(color: Colors.white),
                    formatButtonTextStyle: TextStyle(color: Colors.white)),
                builders: CalendarBuilders(
                    markersBuilder: (context, date, events, _) {
                  return <Widget>[CalendarUtils.buildEventMarker(date, events)];
                }),
              ),
              CalendarUtils.buildEventList(
                  _selectedDayDescriptions, _selectedDay)
            ],
          )),
    );
  }
}
