import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/bloc/agenda_event_bloc.dart';
import 'package:tcc_projeto_app/repository/agenda_repository.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/tiles/event_editor_tile.dart';
import 'package:tcc_projeto_app/widget/utils/calendar_utils.dart';

class UserCalendar extends StatefulWidget {
  final userRepository;
  UserCalendar({@required this.userRepository});

  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  AgendaRepository _agendaRepository;
  AgendaEventBloc _agendaEventBloc;
  Map<DateTime, List<dynamic>> _events;
  List _selectedDayDescriptions;
  CalendarController _controller;
  DateTime _selectedDay;

  UserRepository get userRepository => this.userRepository;
  @override
  void initState() {
    this.userRepository.getUser().then((data) {
      this._agendaRepository = new AgendaRepository(userId: data.uid);
    });
    this._agendaEventBloc =
        new AgendaEventBloc(agendaRepository: this._agendaRepository);

    this._agendaRepository.getEvents().then((data) {
      this._events = data;
    });
    this._selectedDay = DateTime.now();
    this._selectedDayDescriptions = this._events[this._selectedDay];
    super.initState();
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Scaffold.of(context).showBottomSheet(
                (context) {
                  return Container(
                    height: 250,
                    child: EventEditorTile(
                      isEdit: false,
                      agendaEventBloc: this._agendaEventBloc,
                    ),
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
      body: BlocProvider(
          create: (context) => this._agendaEventBloc,
          child: BlocListener<AgendaEventBloc, AgendaEventState>(
            listener: (context, state) {
              if (state is AgendaEventProcessing) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }
            },
            child: BlocBuilder<AgendaEventBloc, AgendaEventState>(
              builder: (context, state) {
                Container(
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
                          events: this._events,
                          calendarController: _controller,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarStyle: _buildCalendarStyle(),
                          headerStyle: _buildHeaderStyle(),
                          builders: CalendarBuilders(
                              markersBuilder: (context, date, events, _) {
                            return <Widget>[
                              CalendarUtils.buildEventMarker(date, events)
                            ];
                          }),
                        ),
                        CalendarUtils.buildEventList(
                            this._selectedDayDescriptions, 
                            this._selectedDay, 
                            this._agendaEventBloc)
                      ],
                    ));
              },
            ),
          )),
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white12),
        todayStyle: TextStyle(color: Colors.white));
  }

  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
        centerHeaderTitle: true,
        formatButtonShowsNext: false,
        titleTextStyle: TextStyle(color: Colors.white),
        formatButtonTextStyle: TextStyle(color: Colors.white));
  }
}
