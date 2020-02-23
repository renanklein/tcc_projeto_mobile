import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/model/agenda_model.dart';
import 'package:tcc_projeto_app/tiles/event_editor_tile.dart';
import 'package:tcc_projeto_app/widget/utils/calendar_utils.dart';

class UserCalendar extends StatefulWidget {
  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  AgendaModel model;
  Future<Map<DateTime, List<dynamic>>> _events;
  List _selectedDayDescriptions;
  CalendarController _controller;
  DateTime _selectedDay;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    this.model = ScopedModel.of<AgendaModel>(context);
    this._controller = new CalendarController();
    this._events = this.model.getEvents();
    super.initState();
  }

  @override
  void didUpdateWidget(UserCalendar oldAgenda){
    super.didUpdateWidget(oldAgenda);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._events,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        } else {
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
                          child: EventEditorTile(
                              isEdit: false, agendaModel: this.model),
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
                          this._selectedDay = date;
                          this._selectedDayDescriptions = events;
                        });
                      },
                      events: snapshot.data,
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
                          formatButtonTextStyle:
                              TextStyle(color: Colors.white)),
                      builders: CalendarBuilders(
                          markersBuilder: (context, date, events, _) {
                        return <Widget>[
                          CalendarUtils.buildEventMarker(date, events)
                        ];
                      }),
                    ),
                    CalendarUtils.buildEventList(this._selectedDayDescriptions,
                        this._selectedDay, this.model)
                  ],
                )),
          );
        }
      },
    );
  }
}
