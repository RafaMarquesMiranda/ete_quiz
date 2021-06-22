import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ete_quiz_app/views/Perfil.dart';
import 'package:ete_quiz_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Cadastro.dart';
import 'Home.dart';
import 'package:ete_quiz_app/models/user.dart';

class Pontuacao extends StatefulWidget {


  @override
  _PontuacaoState createState() => _PontuacaoState();
}

class _PontuacaoState extends State<Pontuacao> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  int _currentIndex = 0;
  String _idUsuarioLogado;
  int _Pontos = 0;

  @override
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

  @override
  void initState(){
    super.initState();
    _recuperarDadosUsuario();
  }

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;


    Firestore db = Firestore.instance;



    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_idUsuarioLogado)
        .get();

    Map<String, dynamic> dados = snapshot.data;

    setState(() {
      _Pontos = dados["pontos"];
    });

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        title: Center(child: appBar(context)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        /*  actions: [
          IconButton(
              icon: Icon(Icons.logout, color: Colors.blue, ),
              onPressed: (){

              }

              ),
        ], */


      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo7.png",
                    width: 200,
                    height: 150,
                  ),
                ),

              Center(child: Text("Sua pontuação : ${_Pontos}")),
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







