import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/screens/event_editor_screen.dart';
import 'package:tcc_projeto_app/agenda/screens/search_bottomsheet.dart';
import 'package:tcc_projeto_app/agenda/utils/calendar_utils.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class UserCalendar extends StatefulWidget {
  final uid;

  UserCalendar({@required this.uid});

  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  AgendaRepository _agendaRepository;
  AgendaBloc _agendaBloc;
  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List<dynamic>> _beforeSearchEvents;
  List _selectedDayDescriptions;
  bool isSearching = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  CalendarController _controller;
  DateTime _selectedDay;

  String get uid => this.widget.uid;

  @override
  void initState() {
    this._events = Map<DateTime, List<dynamic>>();
    var injector = Injector.appInstance;

    this._agendaRepository = injector.get<AgendaRepository>();
    this._agendaRepository.events = this._events;
    this._agendaRepository.userId = this.uid;
    this._agendaBloc = AgendaBloc(agendaRepository: this._agendaRepository);

    _dispatchAgendaLoadEvent();

    this._controller = CalendarController();
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
          title: Text("Agendamentos"),
          actions: [
            IconButton(
                onPressed: () {
                  if (!this.isSearching) {
                    this._scaffoldKey.currentState.showBottomSheet((context) {
                      return SearchBottomSheet(
                          filterFunction: this.filterPacientEvents);
                    });
                  } else {
                    setState(() {
                      this.isSearching = false;
                      _dispatchAgendaLoadEvent();
                    });
                  }
                },
                icon: Icon(
                    this.isSearching ? Icons.cancel_outlined : Icons.search))
          ],
          elevation: 0.0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocProvider<AgendaBloc>(
          create: (context) => this._agendaBloc,
          child: BlocListener<AgendaBloc, AgendaState>(
            listener: (context, state) {
              if (_isEventCreateSuccess(state)) {
                _dispatchAgendaLoadEvent();
              } else if (state is AgendaLoadSuccess) {
                this._events = state.eventsLoaded;
                this._agendaRepository.events = this._events;
                if (this._selectedDay == null) {
                  this._selectedDay = DateTime.now();
                }
                this._selectedDayDescriptions = _retrieveListOfEvents();
              } else if (state is AgendaLoadFail) {
                _buildFailSnackBar();
              } else if (state is AgendaEventsFilterSuccess) {
                this._beforeSearchEvents =
                    Map<DateTime, List<dynamic>>.from(this._events);
                this._events = state.eventsFiltered;
                this._selectedDayDescriptions = _retrieveListOfEvents();
                this.isSearching = true;
              }
            },
            child: BlocBuilder<AgendaBloc, AgendaState>(
              bloc: this._agendaBloc,
              builder: (context, state) {
                if (_isLoadingState(state)) {
                  return LayoutUtils.buildCircularProgressIndicator(context);
                }
                return ListView(
                  children: <Widget>[
                    TableCalendar(
                      locale: "pt_BR",
                      initialSelectedDay: this._selectedDay,
                      onDaySelected: (date, events, _) {
                        setState(() {
                          this._selectedDay = date;
                          this._selectedDayDescriptions =
                              _retrieveListOfEvents();
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
                          CalendarUtils.buildEventMarker(date, events, context)
                        ];
                      }),
                    ),
                    if (this.isSearching)
                      ...this._buildFilteredEventsDisplay(
                          _selectedDayDescriptions, this._selectedDay)
                    else
                      CalendarUtils.buildEventList(
                          this._selectedDayDescriptions,
                          this._selectedDay,
                          this.refresh)
                  ],
                );
              },
            ),
          ),
        ));
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

  bool _isLoadingState(AgendaState state) {
    if (state is EventProcessing || state is AgendaLoading) {
      return true;
    }
    return false;
  }

  bool _isEventCreateSuccess(AgendaState state) {
    if (state is EventProcessingSuccess) {
      return true;
    }
    return false;
  }

  void _buildFailSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        "Ocorreu um erro ao carregar a agenda",
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    ));
  }

  void _dispatchAgendaLoadEvent() {
    this._agendaBloc.add(AgendaLoad());
  }

  void refresh(bool isConfirmedOrCancel) {
    if (isConfirmedOrCancel) {
      Navigator.of(context).pop();
    }
    setState(() {
      _dispatchAgendaLoadEvent();
    });
  }

  void filterPacientEvents(String searchContent) {
    setState(() {
      this._agendaBloc.add(AgendaEventsFilter(
          searchString: searchContent, events: this._events));
    });
  }

  List _retrieveListOfEvents() {
    String eventDay = DateFormat("yyyy-MM-dd").format(this._selectedDay);
    List eventsAsList = [];
    this._events.forEach((date, events) {
      var dateAsString = DateFormat("yyyy-MM-dd").format(date);

      if (eventDay == dateAsString) {
        eventsAsList = events;
      }
    });

    return eventsAsList;
  }

  List<Widget> _buildFilteredEventsDisplay(
      List _selectedDayDescriptions, DateTime selectedDay) {
    var eventWidgets = <Widget>[];

    if (_selectedDayDescriptions.isEmpty) {
      eventWidgets.add(Center(
        child: Text(
          "Não há agendamentos para este dia",
          style: TextStyle(color: Colors.white, fontSize: 15.7),
        ),
      ));
    } else {
      var eventsParsed =
          ConvertUtils.toMapListOfEvents(_selectedDayDescriptions);
      eventsParsed.forEach((element) {
        eventWidgets.add(GestureDetector(
          child: Text(
            "${element['begin']} - ${element['end']}  ${element['description']}",
            style: TextStyle(color: Colors.white, fontSize: 15.7),
          ),
          onTap: () {
            var eventDate = selectedDay;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventEditorScreen(
                    event: element,
                    selectedTime: "${element['begin']} - ${element['end']}",
                    isEdit: true,
                    selectedDay: eventDate,
                    refreshAgenda: refresh)));
          },
        ));
      });
    }

    return eventWidgets;
  }
}
