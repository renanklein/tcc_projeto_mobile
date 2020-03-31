import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/ui/tiles/pacient_tile.dart';

class ViewPacientcreen extends StatefulWidget {
  @override
  _ViewPacientcreenState createState() => _ViewPacientcreenState();
}

class _ViewPacientcreenState extends State<ViewPacientcreen> {
  final searchBarController = TextEditingController();

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu principal"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/createPacient');
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.98,
              child: Column(
                children: <Widget>[
                  PacientSearchBar(searchBarController,
                      'Digite um nome aqui para pesquisar'),
                  _ListPacientView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ListPacientView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/pacientDetail',
                  arguments: 'Dashboard',
                );
              },
              child: PacientTile(
                title: 'Pedro',
                textBody: 'pla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla plapla pla pla pla ',
                imgPath:
                    'https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget PacientSearchBar(controller, hint) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 4.0),
    child: Container(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          hintText: hint,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    ),
  );
}
