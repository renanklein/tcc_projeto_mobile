import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class EventConfirmBottomSheet extends StatefulWidget {
  final eventId;
  final eventDay;
  final refreshAgenda;

  EventConfirmBottomSheet(
      {@required this.eventId,
      @required this.eventDay,
      @required this.refreshAgenda});

  @override
  _EventConfirmBottomSheetState createState() =>
      _EventConfirmBottomSheetState();
}

class _EventConfirmBottomSheetState extends State<EventConfirmBottomSheet> {
  String get eventId => this.widget.eventId;
  DateTime get eventDay => this.widget.eventDay;
  Function get refreshAgenda => this.widget.refreshAgenda;

  AgendaBloc _agendaBloc;
  @override
  void initState() {
    this._agendaBloc = AgendaBloc(
        agendaRepository:
            Injector.appInstance.getDependency<AgendaRepository>());
    super.initState();
  }
  @override
  void dispose() {
    this._agendaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15.0, right: 15.0, bottom: 20.0),
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: BlocListener<AgendaBloc, AgendaState>(
        listener: (context, state){
          if(state is AgendaEventConfirmSuccess){
            Future.delayed(Duration(seconds: 1));
            Navigator.of(context).pop();
            this.refreshAgenda();
          }
        },
        child: BlocBuilder<AgendaBloc, AgendaState>(
          bloc: this._agendaBloc,
          builder: (context, state){
            if(state is AgendaEventProcessing){
              return LayoutUtils.buildCircularProgressIndicator(context);
            }

            return Form(

            );
          },
        ),
      )
    );
  }

  List<Widget> _buildConfirmButtonsList(){
    return <Widget>[

    ];
  }

  Widget _buildConfirmButtom(){
    return Padding(
      padding: EdgeInsets.only(right : 16.0),
      child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Text(
          "Confirmar",
          style: TextStyle(
            
          ),
        ),
        onPressed: (){
          this._agendaBloc.add(AgendaEventConfirmButtomPressed(

          ));
        },
      ),
    );
  }

  Widget _buildCancelButton(){}
}
