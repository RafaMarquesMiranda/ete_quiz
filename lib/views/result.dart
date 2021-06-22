import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ete_quiz_app/models/user.dart';
import 'package:ete_quiz_app/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct,  incorrect ,total;
  Results({@required this.correct,@required this.incorrect,  @required this.total});


  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  String _idUsuarioLogado;
  int _pontos = 0 ;

  Future _atualizarDadosUsuario(int corretas) async {

    User usuario = User();



    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;


    Firestore db = Firestore.instance;



    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_idUsuarioLogado)
        .get();

    Map<String, dynamic> dados = snapshot.data;

    setState(() {
      usuario.nome = dados["nome"];
      usuario.isprofessor =  dados["isprofessor"];
      usuario.pontos =  dados["pontos"] + corretas;
    });
    await db.collection("usuarios")
        .document(_idUsuarioLogado).updateData(usuario.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("${widget.correct} /${widget.total}",style: TextStyle(fontSize:17 ),),
            SizedBox(height: 8,),
            Text("Resultado ${widget.correct} respostas corretas "
                "e ${widget.incorrect}  respostas incorretas" , style: TextStyle(fontSize:15, color: Colors.grey),
            textAlign: TextAlign.center,),
              SizedBox(height: 14,),
              GestureDetector(
                  onTap: (){
                    _atualizarDadosUsuario(widget.correct);
                    Navigator.pop(context);
                  },
                  child: blueButtom(context: context,label: "Volta para o inicio!",buttonWidth: MediaQuery.of(context).size.width/2))
          ],),
        ),
      ),
    );
  }
}

