import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ete_quiz_app/models/question.dart';
import 'package:ete_quiz_app/services/dataService.dart';
import 'package:ete_quiz_app/views/result.dart';
import 'package:ete_quiz_app/widgets/quiz_play_widgets.dart';
import 'package:ete_quiz_app/widgets/widgets.dart';



class playQuiz extends StatefulWidget {
  final String quizId;
  playQuiz(this.quizId);


  @override
  _playQuizState createState() => _playQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;


class _playQuizState extends State<playQuiz> {
    dataService databaseService = new dataService();
    QuerySnapshot questionSnapshot;

    questionModel getQuestionModelFromDatasnapshot(DocumentSnapshot questionSnapshot){
      questionModel QuestionModel  = new questionModel();
      QuestionModel.question = questionSnapshot.data["question"];

      List<String> options = [
        questionSnapshot.data["option1"],
        questionSnapshot.data["option2"],
        questionSnapshot.data["option3"],
        questionSnapshot.data["option4"],
      ];
      options.shuffle();
      QuestionModel.option1 = options[0];
      QuestionModel.option2 = options[1];
      QuestionModel.option3 = options[2];
      QuestionModel.option4 = options[3];
      QuestionModel.corretOption = questionSnapshot.data["option1"];
      QuestionModel.resposta = false;

      return QuestionModel;
    }

  @override
  void initState() {
    //print("ola ${widget.quizId}");
    databaseService.getQuizData(widget.quizId).then((value){
      questionSnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = questionSnapshot.documents.length;
     // print("$total this is total");
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: appBar(context)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black54
        ),
        brightness: Brightness.light,
      ),
      body: Container(
        child:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                questionSnapshot.documents == null ?
                Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ):
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: questionSnapshot.documents.length,
                      itemBuilder: (context, index){
                      return QuizPlayTile(
                          QuestionModel: getQuestionModelFromDatasnapshot(
                              questionSnapshot.documents[index]),
                        index: index,
                      );
                    },
                    )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Results(
                correct: _correct,
                incorrect: _incorrect,
                total: total,
              )
          )
          );
        },
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final questionModel QuestionModel;
  final int index;
  QuizPlayTile({this.QuestionModel,this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSeleted = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("[Q${widget.index+1}] ${widget.QuestionModel.question}" , style: TextStyle(fontSize: 17,color: Colors.black87),),
          SizedBox(height: 12,),
          GestureDetector(
            onTap: (){
              if(!widget.QuestionModel.resposta){
                //corret
                if(widget.QuestionModel.option1 == widget.QuestionModel.corretOption){
                    optionSeleted = widget.QuestionModel.option1;
                    widget.QuestionModel.resposta =true;
                    _correct = _correct +1;
                    _notAttempted = _notAttempted -1;
                    setState(() {

                    });
                }else{
                    optionSeleted = widget.QuestionModel.option1;
                    widget.QuestionModel.resposta =true;
                    _incorrect = _incorrect - 1;
                    _notAttempted = _notAttempted -1;
                    setState(() {

                    });

                }
              }
            },
            child: OptionTile(
              respostaCorreta: widget.QuestionModel.corretOption ,
              descricao: widget.QuestionModel.option1 ,
              option: "A",
              optionSelected: optionSeleted,
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              if(!widget.QuestionModel.resposta){
                //corret
                if(widget.QuestionModel.option2 == widget.QuestionModel.corretOption){
                  optionSeleted = widget.QuestionModel.option2;
                  widget.QuestionModel.resposta =true;
                  _correct = _correct +1;
                  _notAttempted = _notAttempted -1;
                  setState(() {

                  });
                }else{
                  optionSeleted = widget.QuestionModel.option2;
                  widget.QuestionModel.resposta =true;
                  _incorrect = _incorrect - 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {

                  });

                }
              }
            },
            child: OptionTile(
              respostaCorreta: widget.QuestionModel.corretOption ,
              descricao: widget.QuestionModel.option2 ,
              option: "B",
              optionSelected: optionSeleted,
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              if(!widget.QuestionModel.resposta){
                //corret
                if(widget.QuestionModel.option3 == widget.QuestionModel.corretOption){
                  optionSeleted = widget.QuestionModel.option3;
                  widget.QuestionModel.resposta =true;
                  _correct = _correct +1;
                  _notAttempted = _notAttempted -1;
                  setState(() {

                  });
                }else{
                  optionSeleted = widget.QuestionModel.option3;
                  widget.QuestionModel.resposta =true;
                  _incorrect = _incorrect - 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {

                  });

                }
              }
            },
            child: OptionTile(
              respostaCorreta: widget.QuestionModel.corretOption ,
              descricao: widget.QuestionModel.option3 ,
              option: "C",
              optionSelected: optionSeleted,
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              if(!widget.QuestionModel.resposta){
                //corret
                if(widget.QuestionModel.option4 == widget.QuestionModel.corretOption){
                  optionSeleted = widget.QuestionModel.option4;
                  widget.QuestionModel.resposta =true;
                  _correct = _correct +1;
                  _notAttempted = _notAttempted -1;
                  setState(() {

                  });
                }else{
                  optionSeleted = widget.QuestionModel.option4;
                  widget.QuestionModel.resposta =true;
                  _incorrect = _incorrect - 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {

                  });

                }
              }
            },
            child: OptionTile(
              respostaCorreta: widget.QuestionModel.corretOption ,
              descricao: widget.QuestionModel.option4 ,
              option: "D",
              optionSelected: optionSeleted,
            ),
          ),
          SizedBox(height: 20,)

        ],
      ),
    );
  }
}
