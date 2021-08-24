import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/screens/event_editor_screen.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ConfirmEventsScreen extends StatefulWidget {
  final String eventsDate;

  ConfirmEventsScreen(this.eventsDate);

  @override
  _ConfirmEventsScreenState createState() => _ConfirmEventsScreenState();
}

class _ConfirmEventsScreenState extends State<ConfirmEventsScreen> {
  AgendaBloc _agendaBloc;
  List _eventsConfirmed = [];
  TextEditingController _dateController = TextEditingController();
  String get eventsDate => this.widget.eventsDate;

  @override
  void initState() {
    this._agendaBloc = AgendaBloc(
        agendaRepository: Injector.appInstance.get<AgendaRepository>());
    var userModel = Injector.appInstance.get<UserModel>();
    this._agendaBloc.agendaRepository.userId = userModel.uid;
    if (this.eventsDate != null && this.eventsDate.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 300), () {
        this._dateController.text = this.eventsDate;
        this
            ._agendaBloc
            .add(AgendaEventsToBeConfirmed(eventDate: this.eventsDate));
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    this._agendaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consultas a confirmar"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            LayoutUtils.buildVerticalSpacing(10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimeFormField(
                fieldPlaceholder: "Escolha o dia dos agendamentos",
                dateTimeController: _dateController,
                onSelectedDate: () {
                  if (this._dateController.text != null &&
                      this._dateController.text.isNotEmpty) {
                    var splitedDate = this._dateController.text.contains("-") ? this._dateController.text.split("-") : this._dateController.text.split("/");
                    var selectedDate = DateTime(
                        int.tryParse(splitedDate[2]),
                        int.tryParse(splitedDate[1]),
                        int.tryParse(splitedDate[0]));

                    if (selectedDate.difference(DateTime.now()).inDays < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Data selecionada já passou",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )));
                    } else {
                      this._agendaBloc.add(AgendaEventsToBeConfirmed(
                          eventDate: this._dateController.text));
                    }
                  }
                },
              ),
            ),
            LayoutUtils.buildVerticalSpacing(10.0),
            BlocListener<AgendaBloc, AgendaState>(
              bloc: this._agendaBloc,
              listener: (context, state) {
                if (state is AgendaEventsToBeConfirmedSuccess) {
                  this._eventsConfirmed = state.eventsConfirmed;
                }
              },
              child: BlocBuilder<AgendaBloc, AgendaState>(
                bloc: this._agendaBloc,
                builder: (context, state) {
                  if (state is AgendaEventsToBeConfirmedProcessing) {
                    return LayoutUtils.buildCircularProgressIndicator(context);
                  } else if (this._agendaBloc.state
                          is AgendaEventsToBeConfirmedSuccess &&
                      this._eventsConfirmed.isEmpty) {
                    return Center(
                      child: Text(
                        "Não há agendamentos para ${this._dateController.text}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17.0),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        LayoutUtils.buildVerticalSpacing(10.0),
                        ..._buildWidgets(this._eventsConfirmed, state)
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  List<Widget> _buildWidgets(List events, AgendaState state) {
    var widgets = <Widget>[];

    if (state is AgendaEventsToBeConfirmedSuccess) {
      var dateSplited = this._dateController.text.contains("-") ? this._dateController.text.split("-") : this._dateController.text.split("/");

      widgets.add(Center(
        child: Text("Clique no card para editar ou confirmar a consulta",
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 16.0)),
      ));
      widgets.add(LayoutUtils.buildVerticalSpacing(10));

      _sortEvents(events);
      events.forEach((element) {
        widgets.add(EventToBeConfirmedTile(
            refreshList: refreshList,
            event: element,
            eventDate: DateTime(int.tryParse(dateSplited[2]),
                int.tryParse(dateSplited[1]), int.tryParse(dateSplited[0])),
            eventTime: "${element['begin']} - ${element['end']}",
            eventDescription: element["description"].toUpperCase()));
        widgets.add(LayoutUtils.buildVerticalSpacing(10.0));
      });
    }

    return widgets;
  }

  void _sortEvents(List events){
    events.sort((a,b) {

      var now = DateTime.now();
      var startTimeDateA = DateTime(now.year, now.month, now.day, int.tryParse(a['begin'].split(':')[0]), int.tryParse(a['begin'].split(':')[1]));
      var endTimeDateA = DateTime(now.year, now.month, now.day, int.tryParse(a['end'].split(':')[0]), int.tryParse(a['end'].split(':')[1]));

      var startTimeDateB = DateTime(now.year, now.month, now.day, int.tryParse(b['begin'].split(':')[0]), int.tryParse(b['begin'].split(':')[1]));
      var endTimeDateB = DateTime(now.year, now.month, now.day, int.tryParse(b['end'].split(':')[0]), int.tryParse(b['end'].split(':')[1]));

      if(startTimeDateA.isBefore(startTimeDateB) && endTimeDateA.isBefore(endTimeDateB)){
        return -1;
      }

      return 1;
    });
  }

  void refreshList(bool boolArg) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ConfirmEventsScreen(this._dateController.text)));
  }
}

class EventToBeConfirmedTile extends StatelessWidget {
  final refreshList;
  final event;
  final DateTime eventDate;
  final String eventTime;
  final String eventDescription;
  EventToBeConfirmedTile(
      {@required this.eventTime,
      @required this.eventDate,
      @required this.eventDescription,
      @required this.event,
      @required this.refreshList});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => EventEditorScreen(
                      isEdit: true,
                      selectedDay: this.eventDate,
                      selectedTime: this.eventTime,
                      refreshAgenda: this.refreshList,
                      event: this.event,
                    )))
            .then((value) => this.refreshList(false));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: Color(0xFF84FFFF),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
              child: Text(
                this.eventTime,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
              child: Text(
                this.eventDescription,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
