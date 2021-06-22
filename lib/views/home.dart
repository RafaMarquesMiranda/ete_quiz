import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ete_quiz_app/views/Pontuacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ete_quiz_app/helper/funcion.dart';
import 'package:ete_quiz_app/models/user.dart';
import 'package:ete_quiz_app/services/auth.dart';
import 'package:ete_quiz_app/services/dataService.dart';
import 'package:ete_quiz_app/views/Login.dart';
import 'package:ete_quiz_app/views/create_quiz.dart';
import 'package:ete_quiz_app/views/playQuiz.dart';
import 'package:ete_quiz_app/widgets/widgets.dart';
import 'package:ete_quiz_app/views/Perfil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Stream quizStream;
  dataService databaseService = new dataService();
  AuthServices authService = new AuthServices();
  String _idUsuarioLogado;
  String _nome ="";
  bool _isProf =false;
  int _pontos = 0 ;
  int _currentIndex = 0;

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
      _pontos = dados["pontos"];
      _isProf = dados["isprofessor"];
    });

  }

  Widget quizList(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot){
          return snapshot.data == null ? Container(): ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context , index){
            return Quiztile(
              imgUrl: snapshot.data.documents[index].data["quizImage"],
              desc: snapshot.data.documents[index].data["quizDesc"],
              title: snapshot.data.documents[index].data["quizTitle"],
              quizId: snapshot.data.documents[index].data["quizId"],
            );
          });
        },
      ),

    );

  }

    @override
  void initState(){

    databaseService.getQuizezData().then((value){
      setState(() {
        quizStream = value;

      });
    });

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
        brightness: Brightness.light,
      /*  actions: [
          IconButton(
              icon: Icon(Icons.logout, color: Colors.blue, ),
              onPressed: (){

              }

              ),
        ], */


      ),
      drawer: Drawer(

        child: ListView(

          padding: EdgeInsets.all(10),
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:  AssetImage('imagens/logo7.png'))
              ),
             // child: Text('ETE  quiz'),

            ),
            ListTile(
              title: Text(_nome),

              onTap: () {
                //  _recuperarDadosUsuario();
                Navigator.pop(context);
                //Navigator.pop(context);
              },
            ),

            ListTile(
                title: Text('Mudar conta '),
              onTap: () {
                authService.singOut();
                HelperFunctions.saveUserLoggedInDetails(inLoggedin: false );
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
            ListTile(
              title: Text('Sair'),

              onTap: () {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                });
                //Navigator.pop(context);
                //Navigator.pop(context);
              },
            ),


          ],
        ),
      ),

      body: quizList(),

        floatingActionButton: _isProf?   FloatingActionButton(
           child:  Icon(Icons.add),
          onPressed: () {
                Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateQuiz()));
          }
        ):Container(),
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
}

class Quiztile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;


  Quiztile({@required this.imgUrl,
    @required this.title,
    @required this.desc,
  @required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(
            builder: (context) => playQuiz(quizId)
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imgUrl, width: MediaQuery.of(context).size.width -48, fit: BoxFit.cover,)),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),

              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(title, style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500) ),
                SizedBox(height: 6,),
                Text(desc, style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500) ),
              ],),
            )
          ],
        ),
      ),
    );

  }

}
