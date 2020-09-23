import 'package:flutter/material.dart';

class PacientTile extends StatelessWidget {
  final String imgPath;
  final String title;
  final String textBody;

  PacientTile({this.title, this.textBody, this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: Color(0xFF84FFFF),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 3.0, 4.0, 4.0),
            child: Container(
              constraints: BoxConstraints.expand(
                width: 90,
                height: 90,
              ),
              decoration:
                  BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
              child: Image.network(imgPath),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  title,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textBody,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
