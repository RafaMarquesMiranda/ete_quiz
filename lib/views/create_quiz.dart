import 'package:flutter/material.dart';
import 'package:ete_quiz_app/services/dataService.dart';
import 'package:ete_quiz_app/views/addQuestion.dart';
import 'package:ete_quiz_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImagemUrl, quizTitulo, quizDescricao, quizId;
  dataService databaseService = new dataService();
  bool _isLoadin = false;

  createQuizOnline() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoadin = true;
      });
      quizId = randomAlphaNumeric(16);
      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImage": quizImagemUrl,
        "quizTitle": quizTitulo,
        "quizDesc": quizDescricao
      };
      await databaseService.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoadin = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => addQuestion(
            quizId
          )));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: appBar(context)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _isLoadin
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  children: [
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Entrar com imagem" : null,
                      decoration: InputDecoration(
                        hintText: "Digite url da Imagem de seu Quiz",
                      ),
                      onChanged: (value) {
                        quizImagemUrl = value;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Entrar com imagem" : null,
                      decoration: InputDecoration(
                        hintText: "Digite o titulo de seu Quiz",
                      ),
                      onChanged: (value) {
                        quizTitulo = value;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Entrar com imagem" : null,
                      decoration: InputDecoration(
                        hintText: "Digite a descrição de seu Quiz",
                      ),
                      onChanged: (value) {
                        quizDescricao = value;
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        createQuizOnline();
                      },
                      child: blueButtom(
                          context: context,
                          label :"Cadastrar Quiz"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
