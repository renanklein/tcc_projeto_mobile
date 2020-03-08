import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/bloc/agenda_event_bloc.dart';
import 'package:tcc_projeto_app/repository/agenda_repository.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/tiles/event_editor_tile.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/widget/utils/calendar_utils.dart';

class UserCalendar extends StatefulWidget {
  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  UserRepository _userRepository;
  AgendaRepository _agendaRepository;
  AgendaEventBloc _agendaEventBloc;
  Map<DateTime, List<dynamic>> _events;
  List _selectedDayDescriptions;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  CalendarController _controller;
  DateTime _selectedDay;

  @override
  void initState() {
    var injector = Injector.appInstance;
    this._userRepository = injector.getDependency<UserRepository>();
    this._agendaRepository = injector.getDependency<AgendaRepository>();
    this._agendaEventBloc =
        new AgendaEventBloc(agendaRepository: this._agendaRepository);
    _buildEvents();
    this._controller = new CalendarController();
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
                  return LayoutUtils.buildCircularProgressIndicator(context);
                }
              },
              child: BlocBuilder<AgendaEventBloc, AgendaEventState>(
                bloc: this._agendaEventBloc,
                builder: (context, state) {
                  return Container(
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
            )));
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

  Future<void> _buildEvents() async {
    this._events = await this._agendaRepository.getEvents();
    this._selectedDay = DateTime.now();
    this._selectedDayDescriptions = this._events[this._selectedDay];
  }
}
