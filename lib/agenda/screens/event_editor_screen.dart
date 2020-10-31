import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/agenda/screens/elements/event_date.dart';
import 'package:tcc_projeto_app/agenda/screens/elements/event_hour.dart';
import 'package:tcc_projeto_app/agenda/screens/elements/event_name.dart';
import 'package:tcc_projeto_app/agenda/screens/elements/event_status.dart';
import 'package:tcc_projeto_app/agenda/tiles/event_confirm.dart';
import 'package:tcc_projeto_app/agenda/tiles/event_exclude_reason.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class EventEditorScreen extends StatefulWidget {
  final event;
  final isEdit;
  final selectedDay;
  final selectedTime;
  final refreshAgenda;
  final isoCode = "BR";
  final dialCode = "+55";

  EventEditorScreen(
      {@required this.event,
      @required this.isEdit,
      @required this.selectedDay,
      @required this.selectedTime,
      @required this.refreshAgenda});

  @override
  _EventEditorScreenState createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends State<EventEditorScreen> {
  AgendaBloc agendaBloc;
  List<String> occupedHours;
  TextEditingController _eventStatusController;
  TextEditingController _eventNameController;
  TextEditingController _eventHourController;
  TextEditingController _eventPhoneController;
  PhoneNumber eventPhone;
  final formKey = new GlobalKey<FormState>();

  Map get event => this.widget.event;
  bool get isEdit => this.widget.isEdit;
  String get isoCode => this.widget.isoCode;
  String get dialCode => this.widget.dialCode;
  String get selectedTime => this.widget.selectedTime;
  DateTime get selectedDay => this.widget.selectedDay;
  Function get refreshAgenda => this.widget.refreshAgenda;

  @override
  void initState() {
    this.agendaBloc = new AgendaBloc(
        agendaRepository:
            Injector.appInstance.getDependency<AgendaRepository>());

    this._eventNameController = TextEditingController(
        text: this.event == null ? "" : this.event["description"]);

    this._eventPhoneController = TextEditingController(
        text: this.event == null ? "" : this.event["phone"]);

    this._eventStatusController = TextEditingController(
        text: this.event == null ? "" : this.event["status"]);

    this.eventPhone = PhoneNumber(
        phoneNumber: this._eventPhoneController.text,
        dialCode: this.dialCode,
        isoCode: this.isoCode);

    this.agendaBloc.add(AgendaEventAvailableTimeLoad(day: this.selectedDay));
    this._eventHourController = TextEditingController();
    this._eventHourController.text = this.event == null
        ? null
        : "${this.event["begin"]} - ${this.event["end"]}";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Agendar Consulta"),
          elevation: 0.0,
        ),
        body: BlocProvider<AgendaBloc>(
          create: (context) => this.agendaBloc,
          child: BlocListener<AgendaBloc, AgendaState>(
            listener: (context, state) {
              if (_verifySuccessState(state)) {
                _onSuccessState();
              } else if (_verifyFailState(state)) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Ocorreu um error ao ${this.isEdit ? "editar" : "criar"} o evento",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )));
              } else if (state is AgendaAvailableTimeFail) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Ocorreu um erro ao carregar os horário vagos",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )));
              }
            },
            child: BlocBuilder<AgendaBloc, AgendaState>(
              builder: (context, state) {
                if (_isLoadingState(state)) {
                  return LayoutUtils.buildCircularProgressIndicator(context);
                } else if (state is AgendaAvailableTimeSuccess) {
                  return Form(
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        ..._buildFields(state),
                        ..._buildStatusButtons(),
                        LayoutUtils.buildVerticalSpacing(20.0),
                        _buildCreateEventButton(),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
  }

  Widget _buildCreateEventButton() {
    return SizedBox(
      height: 44.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: Theme.of(context).primaryColor,
        child: Text(
          "${this.isEdit ? "Editar Agendamento" : "Criar Agendamento"}",
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          _createOrEditEvent();
        },
      ),
    );
  }

  bool _isLoadingState(AgendaState state) {
    return state is EventProcessing || state is AgendaAvailableTimeLoading;
  }

  List<Widget> _buildStatusButtons() {
    var buttonsList = <Widget>[];

    if (this.isEdit) {
      buttonsList.add(_buildCancelButton());
      buttonsList.add(_buildConfirmButton());

      return <Widget>[
        Center(
          child: Text("Clique para confirmar ou cancelar a consulta",
              style: TextStyle(
                  fontSize: 16.0, color: Theme.of(context).primaryColor)),
        ),
        LayoutUtils.buildVerticalSpacing(10.0),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buttonsList)
      ];
    }

    return <Widget>[];
  }

  List<Widget> _buildFields(AgendaAvailableTimeSuccess state) {
    var fieldsList = <Widget>[];

    fieldsList
        .add(EventNameField(eventNameController: this._eventNameController));
    fieldsList.add(LayoutUtils.buildVerticalSpacing(20.0));
    if (this.isEdit) {
      fieldsList.add(EventStatus(
        eventStatus: this._eventStatusController.text,
      ));
      fieldsList.add(LayoutUtils.buildVerticalSpacing(20.0));
    }
    fieldsList.add(EventDate(selectedDay: this.selectedDay));
    fieldsList.add(LayoutUtils.buildVerticalSpacing(20.0));
    fieldsList.add(
      EventHourField(
        selectedTime: this.selectedTime,
        occupedHours: state.occupedTimes,
        hourController: this._eventHourController,
      ),
    );
    fieldsList.add(LayoutUtils.buildVerticalSpacing(20.0));
    fieldsList.add(this._buildEventPhoneField());
    fieldsList.add(LayoutUtils.buildVerticalSpacing(20.0));

    return fieldsList;
  }

  void _createOrEditEvent() {
    var eventStart = this._eventHourController.text.split("-")[0].trim();
    var eventEnd = this._eventHourController.text.split("-")[1].trim();

    if (this.widget.isEdit) {
      agendaBloc.add(AgendaEditButtonPressed(
          eventId: this.event["id"].toString(),
          eventDay: this.selectedDay,
          eventName: this._eventNameController.text,
          eventPhone: this._eventPhoneController.text,
          eventStart: eventStart,
          eventEnd: eventEnd,
          eventStatus: this.event["status"]));
    } else {
      agendaBloc.add(AgendaCreateButtonPressed(
          eventDay: this.selectedDay,
          eventName: this._eventNameController.text,
          eventPhone: this._eventPhoneController.text,
          eventStart: eventStart,
          eventEnd: eventEnd));
    }
  }

  Widget _buildEventPhoneField() {
    return InternationalPhoneNumberInput(
      initialValue: eventPhone,
      onInputChanged: (phone) {},
      inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: "Telefone"),
      textFieldController: this._eventPhoneController,
    );
  }

  void _onSuccessState() {
    Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
    this.refreshAgenda(false);
  }

  bool _verifySuccessState(AgendaState state) {
    return state is EventProcessingSuccess;
  }

  bool _verifyFailState(AgendaState state) {
    return state is EventProcessingFail;
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      height: 44.0,
      width: 150.0,
      child: Builder(
        builder: (context) => RaisedButton(
          onPressed: () {
            Scaffold.of(context).showBottomSheet((context) {
              return EventConfirmBottomSheet(
                  event: this.event,
                  eventDay: this.selectedDay,
                  refreshAgenda: this.refreshAgenda);
            }, backgroundColor: Colors.transparent);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          color: Colors.green[600],
          child: Text(
            "Confirmar",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      height: 44.0,
      width: 150.0,
      child: Builder(
        builder: (context) => RaisedButton(
          onPressed: () {
            Scaffold.of(context).showBottomSheet(
              (context) {
                return EventExcludeBottomSheet(
                    eventId: this.event["id"].toString(),
                    eventDay: this.selectedDay,
                    refreshAgenda: this.refreshAgenda);
              },
              backgroundColor: Colors.transparent,
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          color: Colors.red[300],
          child: Text(
            "Cancelar",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
