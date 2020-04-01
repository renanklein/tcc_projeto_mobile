import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final text;
  final icon;
  final onTapCallback;
  DrawerTile({@required this.text, @required this.icon, @required this.onTapCallback});

  @override
  Widget build(BuildContext context) 
  {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 30.0,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 25.0,),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).primaryColor
            ),
          )
        ],
      ),
      onTap: (){},
    );
  }
}