import 'package:flutter/material.dart';

class EventAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/images/avatar_placeholder.jpg"),
      ),
    );
  }
}
