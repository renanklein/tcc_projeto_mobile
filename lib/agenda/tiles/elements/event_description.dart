import 'package:flutter/material.dart';

class EventDescription extends StatelessWidget {
  final eventText;
  final eventHourStart;
  final eventHourEnd;

  EventDescription({
    @required this.eventText,
    @required this.eventHourStart,
    @required this.eventHourEnd});
  
  String get eventStart => this.eventHourStart;
  String get eventEnd => this.eventHourEnd;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_buildEventTitle(), _buildEventTimeRange()]),
    );
  }

  Widget _buildEventTitle() {
    return Text(
      this.eventText,
      style: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 20.0),
    );
  }

  Widget _buildEventTimeRange() {
    return Text(
      "${this.eventStart} - ${this.eventEnd}",
      style: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 14.0),
    );
  }

}
