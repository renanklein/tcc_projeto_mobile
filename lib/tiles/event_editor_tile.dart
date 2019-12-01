import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class EventEditorTile extends StatefulWidget {
  String eventText;
  DateTime eventDate;

  EventEditorTile({ @required this.eventText, @required this.eventDate});

  @override
  _EventEditorTileState createState() => _EventEditorTileState();
}

class _EventEditorTileState extends State<EventEditorTile> {
  final _eventNameController = TextEditingController();

  final _eventDateController = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(top : 5, left: 15.0,right: 15.0, bottom: 5),
      padding: EdgeInsets.only(top: 10.0,left: 10.0 ,right: 10.0),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child : Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _eventNameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0)
                ),
                hintText: "Nome do evento"
              ),
            ),
            SizedBox(height: 10.0,),
            DateTimeField(
              controller: _eventDateController,
              onShowPicker: (context, date) async{
                return showDatePicker(
                  firstDate: DateTime.now(),
                  initialDate: date ?? DateTime.now(),
                  lastDate: DateTime(2030), 
                  context: context 
                );
              },
              format: DateFormat("DD-MM"),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                hintText: "Data do evento",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
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
                      borderRadius: BorderRadius.circular(15.0)
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
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Registrar",
                      style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white),
                    ),
                    onPressed: (){
                      setState(() {
                        this.widget.eventText = this._eventNameController.text;
                        this.widget.eventDate = DateTime.parse(this._eventDateController.text);
                      });
                      Future.delayed(Duration(seconds: 1));
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}