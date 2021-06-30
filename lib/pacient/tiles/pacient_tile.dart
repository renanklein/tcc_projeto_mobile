import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';

class PacientTile extends StatefulWidget {
  final String imgPath;
  final String title;
  final String textBody;
  final String cpf;
  final String salt;
  final PacientBloc pacientBloc;

  PacientTile({
    this.title,
    this.textBody,
    this.imgPath,
    this.cpf,
    this.salt,
    this.pacientBloc,
  });

  _PacientTileState createState() => _PacientTileState();
}

class _PacientTileState extends State<PacientTile> {
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
              child: Image.network(this.widget.imgPath),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  this.widget.title,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        this.widget.textBody,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      this.widget.pacientBloc.add(
                            ViewPacientOverviewButtonPressed(
                              cpf: this.widget.cpf,
                              salt: this.widget.salt,
                            ),
                          );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
