import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/models/agenda_model.dart';
import 'package:tcc_projeto_app/tiles/event_editor_tile.dart';
import 'package:tcc_projeto_app/widget/utils/calendar_utils.dart';

class UserCalendar extends StatefulWidget {
  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  Map<DateTime, List<dynamic>> _events;
  List _selectedDayDescriptions;
  CalendarController _controller;
  DateTime _selectedDay;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _controller = new CalendarController();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AgendaModel>(builder: (context, child, model) {
      if(model.isLoading){
        this._events = model.getEvents();
        this._selectedDayDescriptions = this._events[_selectedDay];
      }
      
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Agenda"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _scaffoldKey.currentState.showBottomSheet(
                  (context) {
                    return Container(
                      height: 250,
                      child: EventEditorTile(isEdit: false, agendaModel: model),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                );
              },
            )
          ],
          elevation: 0.0,
        ),
        body: Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
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
                    return <Widget>[
                      CalendarUtils.buildEventMarker(date, events)
                    ];
                  }),
                ),
                CalendarUtils.buildEventList(
                    _selectedDayDescriptions, _selectedDay, model)
              ],
            )),
      );
    });
  }
}
