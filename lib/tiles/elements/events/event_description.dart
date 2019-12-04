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
            Text(
              this.eventText,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0),
            ),
            Text(
              "${this.eventDate.day}",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 14.0),
            )
          ]),
    );
  }
}
