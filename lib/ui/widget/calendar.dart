import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_projeto_app/ui/widget/utils/calendar_utils.dart';
import 'package:tcc_projeto_app/bloc/agenda_bloc.dart';
import 'package:tcc_projeto_app/repository/agenda_repository.dart';
import 'package:tcc_projeto_app/ui/screens/event_editor_screen.dart';
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
  List _selectedDayDescriptions;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  CalendarController _controller;
  DateTime _selectedDay;

  String get uid => this.widget.uid;

  @override
  void initState() {
    this._events = new Map<DateTime, List<dynamic>>();
    var injector = Injector.appInstance;

    this._agendaRepository = injector.getDependency<AgendaRepository>();
    this._agendaRepository.events = this._events;
    this._agendaRepository.userId = this.uid;

    this._agendaBloc = new AgendaBloc(agendaRepository: this._agendaRepository);

    _dispatchAgendaLoadEvent();
    
    this._controller = new CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    this._agendaBloc.close();
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EventEditorScreen(
                        event: null,
                        isEdit: false,
                        selectedDay: this._selectedDay,
                        agendaRepository: this._agendaRepository,
                  ))
                );
              }
            )
          ],
          elevation: 0.0,
        ),
        body: BlocProvider(
            create: (context) => this._agendaBloc,
            child: BlocListener<AgendaBloc, AgendaState>(
              listener: (context, state) {
                if (_isEventCreateSuccess(state)) {
                 _dispatchAgendaLoadEvent();
                }
                else if(state is AgendaLoadSuccess){
                  this._events = state.eventsLoaded;
                  this._agendaRepository.events = this._events;
                  this._selectedDay = DateTime.now();
                  this._selectedDayDescriptions = this._events[this._selectedDay];
                }
                else if(state is AgendaLoadFail){
                  _buildFailSnackBar();
                }
              },
              child: BlocBuilder<AgendaBloc, AgendaState>(
                bloc: this._agendaBloc,
                builder: (context, state) {
                  if (_isLoadingState(state)) {
                    return LayoutUtils.buildCircularProgressIndicator(context);
                  }
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
                              this._agendaRepository)
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

  bool _isLoadingState(AgendaState state) {
    if (state is AgendaEventProcessing || state is AgendaLoading) {
      return true;
    }
    return false;
  }

  bool _isEventCreateSuccess(AgendaState state) {
    if (state is AgendaEventEditSuccess || state is AgendaEventEditSuccess || state is AgendaEventDeleteSuccess) {
      return true;
    }
    return false;
  }
  
  void _buildFailSnackBar(){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Ocorreu um erro ao carregar a agenda",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
      )
    );
  }

  void _dispatchAgendaLoadEvent() {
    this._agendaBloc.add(AgendaLoad());
  }
}
