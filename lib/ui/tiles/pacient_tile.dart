import 'package:flutter/material.dart';

class PacientTile extends StatelessWidget {
  final String imgPath;
  final String title;
  final String textBody;

  PacientTile({this.title, this.textBody, this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color(0xFF84FFFF),
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 124,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints.expand(
                    width: MediaQuery.of(context).size.width / 4,
                    height: 95.0,
                  ),
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      textBody,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
