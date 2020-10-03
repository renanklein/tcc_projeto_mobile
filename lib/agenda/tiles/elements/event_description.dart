import 'package:flutter/material.dart';

class EventDescription extends StatelessWidget {
  final eventText;
  final eventStatus;
  final eventPhone;
  final eventHourStart;
  final eventHourEnd;

  EventDescription(
      {@required this.eventText,
      @required this.eventStatus,
      @required this.eventPhone,
      @required this.eventHourStart,
      @required this.eventHourEnd});

  String get eventStart => this.eventHourStart;
  String get eventEnd => this.eventHourEnd;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: <Widget>[
        _buildEventTitle(),
        _buildEventPhone(),
        _buildEventStatus(),
        _buildEventTimeRange()
      ]),
    );
  }

  Widget _buildEventTitle() {
    return Container(
      child: Text(
        this.eventText,
        strutStyle: StrutStyle(),
        style: TextStyle(
            color: this.eventStatus == "confirmed" ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 15.0),
      ),
    );
  }

  Widget _buildEventPhone() {
    return Text(
      this.eventPhone,
      strutStyle: StrutStyle(),
      style: TextStyle(
          color: this.eventStatus == "confirmed" ? Colors.black : Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 15.0),
    );
  }

  Widget _buildEventTimeRange() {
    return Text(
      "${this.eventStart} - ${this.eventEnd}",
      style: TextStyle(
          color: this.eventStatus == "confirmed" ? Colors.black : Colors.grey,
          fontWeight: FontWeight.w300,
          fontSize: 14.0),
    );
  }

  Widget _buildEventStatus() {
    return Container(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Text(
        this.eventStatus,
        style: TextStyle(
            color: this.eventStatus == "confirmed" ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14.0),
      ),
    );
  }
}
