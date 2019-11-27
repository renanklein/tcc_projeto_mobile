import 'package:flutter/material.dart';

class CalendarEventTile extends StatelessWidget {
  String eventText;
  DateTime eventDate;
  CalendarEventTile({@required this.eventText, @required this.eventDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
        ),
        duration: Duration(milliseconds: 3000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage("assets/images/avatar_placeholder.jpg"),
            ),
            SizedBox(width: 20.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  eventText,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0
                  ),
                ),
                Text(
                  "${eventDate.day}",
                  style: TextStyle(
                    color : Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 14.0
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: (){
        Scaffold.of(context).showBottomSheet((context){
          return Container(
            child: Text("Tela para editar evento"),
          );
        });
      },
    );
  }
 
}
