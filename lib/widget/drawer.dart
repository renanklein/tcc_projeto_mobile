import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/tiles/drawer_tile.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 16.0,
        child: ListView(
          children: <Widget>[
            _createDrawerHeader(),
            DrawerTile(
                icon: Icons.person, text: "pacientes", onTapCallback: null),
            DrawerTile(
                icon: Icons.event_note, text: "exames", onTapCallback: null),
            DrawerTile(
                icon: Icons.assignment, text: "anamnese", onTapCallback: null),
            DrawerTile(
                icon: Icons.info, text: "relatorios", onTapCallback: null),
            Divider(),
            DrawerTile(
                icon: Icons.bug_report, text: "relatar erros", onTapCallback: null),
          ],
        ));
  }

  Widget _createDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/drawer_header.jpg"),
            fit: BoxFit.cover
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.transparent,
                // placeholder code, that image should be obtained from firebase
                backgroundImage: AssetImage("assets/images/avatar_placeholder.jpg")
            ),
            SizedBox(width: 30.0,),
            Text(
              "Fulano de tal",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 25.0
              ),
            )
          ],
        ),
      ),
    );
  }
}
