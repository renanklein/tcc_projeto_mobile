import 'package:flutter/material.dart';

class EventDescription extends StatelessWidget {
  String eventText;
  DateTime eventDate;

  EventDescription({@required this.eventText, @required this.eventDate});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildEventTitle(),
            _buildEventDate()
          ]),
    );
  }

  Widget _buildEventTitle() {
    return Text(
      this.eventText,
      style: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 20.0),
    );
  }

  Widget _buildEventDate() {
    return Text(
      "Horário ${eventDate.hour} : ${eventDate.minute}",
      style: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 14.0),
    );
  }
}
