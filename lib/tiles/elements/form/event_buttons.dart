import 'package:flutter/material.dart';

class EventButtons extends StatefulWidget {
  @override
  _EventButtonsState createState() => _EventButtonsState();
}

class _EventButtonsState extends State<EventButtons> {
  
  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: RaisedButton(
                    color: Colors.grey,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Registrar",
                      style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white),
                    ),
                    onPressed: (){
                      // some action ... 
                      Future.delayed(Duration(seconds: 1));
                      Navigator.of(context).pop();
                    },
                  ),
                )],
            );
  }
}