import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/ui/tiles/pacient_tile.dart';

class ViewPacientcreen extends StatefulWidget {
  @override
  _ViewPacientcreenState createState() => _ViewPacientcreenState();
}

class _ViewPacientcreenState extends State<ViewPacientcreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu principal"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: _ListPacientView(),      
        ),
      );
 
  }

  Widget _ListPacientView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PacientTile(
                    title: 'Pedro',
                    textBody: 'pla pla pla pla ',
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PacientTile(
                    title: "Jõao",
                    textBody: "jla jla jla jla ",
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PacientTile(
                    title: "Maria",
                    textBody: "mla mla mla mla ",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
