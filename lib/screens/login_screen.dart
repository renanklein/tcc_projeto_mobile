import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// TODO : Inserir no projeto o lib ScopedModel para mudança de telas ao logar/deslogar
class _LoginScreenState extends State<LoginScreen> {

  final email_controller = new TextEditingController();
  final pass_controller = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          FlatButton(
            child: Text("Criar Conta",
            style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SignupScreen())
              );
            },
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
              radius: 48.0,
              backgroundColor: Colors.transparent,
              child: Image.network("https://images.vexels.com/media/users/3/144230/isolated/preview/79526c38c6e5fe4b75f08d2d3a5af28c-conta-gotas-s--mbolo-m--dico-cruz-by-vexels.png"),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: email_controller,
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
              controller: pass_controller,
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

            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  "Esqueci minha senha",
                  textAlign: TextAlign.right,
                  ),
                  padding: EdgeInsets.zero,
                onPressed: (){
                  scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text("Foi enviado um formulário de mudança de senha para o email cadastrado"),
                    ));
                },
              ),
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
                child: Text("Entrar", 
                style : TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                )),
                onPressed: (){},
              )
            ),
            
          ],
        ),
      )
    );
  }
}