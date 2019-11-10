import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                 contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                 border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(32.0)
                ),
                hintText: "Nome Completo",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)
                ),
                hintText: "E-mail",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _passController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)
                ),
                hintText: "Senha",
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            DropdownButtonFormField(
              items: _getDropdownMenuItems(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)
                ),
            )
            ),

            SizedBox(
              height: 20.0,
            ),

            SizedBox(
              height: 44.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text("Criar Conta", 
                style : TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                )),
                onPressed: (){
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Conta criada com sucesso !"),
                    backgroundColor: Colors.green,
                  ));
                },
              )
            )
          ],
        ),
      )
    );
  }

   List<DropdownMenuItem> _getDropdownMenuItems(){

     final medico = DropdownMenuItem(
       child: Text("Médico"),
     );

     final paciente = DropdownMenuItem(
       child : Text("Paciente")
     );

     final list =  List<DropdownMenuItem>();

     list.add(medico);
     list.add(paciente);

     return list;

   }
}