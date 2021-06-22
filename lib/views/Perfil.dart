import 'package:ete_quiz_app/views/Pontuacao.dart';
import 'package:ete_quiz_app/views/home.dart';
import 'package:ete_quiz_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';


class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerSerie = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  int _currentIndex = 0;
  String _idUsuarioLogado;
  bool _isProf =false;

  _atualizarNomeFirestore(){

    String nome = _controllerNome.text;
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome
    };

    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData( dadosAtualizar );

  }
  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
    });
    switch (_currentIndex) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Pontuacao()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()));
        break;
    }

  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
      .document( _idUsuarioLogado )
      .get();

    Map<String, dynamic> dados = snapshot.data;
    _controllerNome.text = dados["nome"];
    _controllerEmail.text = dados["email"];
    _controllerSerie.text = dados["serie"];
    setState(() {
      _isProf = dados["isprofessor"];
    });



  }



  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
    title: Center(child: appBar(context)),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    brightness: Brightness.light,),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    /*onChanged: (texto){
                      _atualizarNomeFirestore(texto);
                    },*/
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _isProf?  Text("PROFESSOR"):TextField(
                    controller: _controllerSerie,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    /*onChanged: (texto){
                      _atualizarNomeFirestore(texto);
                    },*/
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Serie",
                        enabled: false,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    /*onChanged: (texto){
                      _atualizarNomeFirestore(texto);
                    },*/
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Email",
                        enabled: false,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.blue,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _atualizarNomeFirestore();
                      }
                  ),
                )

              ],

            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        elevation:3,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            title: Text('inicio',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt, color: Colors.black,),
            title: Text('Pontuação',
                style: TextStyle(color: Colors.black) ),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.black,),
            title: Text('Perfil',
                style: TextStyle(color: Colors.black) ),

          ),
        ],
      ),
    );
  }
}
