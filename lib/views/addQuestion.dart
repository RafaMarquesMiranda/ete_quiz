import 'package:flutter/material.dart';
import 'package:ete_quiz_app/services/dataService.dart';
import 'package:ete_quiz_app/widgets/widgets.dart';

class addQuestion extends StatefulWidget {
   final String quizId;
   addQuestion(this.quizId);

  @override
  _addQuestionState createState() => _addQuestionState();
}

class _addQuestionState extends State<addQuestion> {

  final _formKey = GlobalKey<FormState>();
  String Question, option1, option2, option3, option4;
  bool _isLoading = false;

  dataService databaseService = new dataService();

  uploadQuestionData() async{

    if(_formKey.currentState.validate()){

         setState(() {
           _isLoading =true;
         });

         Map<String,String> questionMap = {
           "question" : Question,
           "option1" : option1,
           "option2" : option2,
           "option3" : option3,
           "option4" : option4,
         };
         await databaseService.addQuestionData(questionMap, widget.quizId).then((value){
           setState(() {
             _isLoading = false;
           });
         });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Center(
          child: appBar(context)),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    body: _isLoading ? Container(
          child: Center(child: CircularProgressIndicator(),),
    ): Form(
       key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ListView(children: [
          TextFormField(
            validator: (value) =>
            value.isEmpty ? "Entrar com questão" : null,
            decoration: InputDecoration(
              hintText: "Digite a questão",
            ),
            onChanged: (value) {
              Question = value;
            },
          ),
          SizedBox(
            height: 6,
          ),
          TextFormField(
            validator: (value) =>
            value.isEmpty ? "Entrar com alternativa 1 (Correta)" : null,
            decoration: InputDecoration(
              hintText: "Digite a alternativa 1 (Correta)",
            ),
            onChanged: (value) {
              option1 = value;
            },
          ),
          SizedBox(
            height: 6,
          ),
          TextFormField(
            validator: (value) =>
            value.isEmpty ? "Entrar com alternativa 2" : null,
            decoration: InputDecoration(
              hintText: "Digite a alternativa 2",
            ),
            onChanged: (value) {
              option2 = value;
            },
          ),
          TextFormField(
            validator: (value) =>
            value.isEmpty ? "Entrar com alternativa 3" : null,
            decoration: InputDecoration(
              hintText: "Digite a alternativa 3",
            ),
            onChanged: (value) {
              option3 = value;
            },
          ),
          TextFormField(
            validator: (value) =>
            value.isEmpty ? "Entrar com alternativa 4" : null,
            decoration: InputDecoration(
              hintText: "Digite a alternativa 4",
            ),
            onChanged: (value) {
              option4 = value;
            },
          ),
          Spacer(),
          Row(children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: blueButtom(
                  context: context,
                  label :"Submeter",
                  buttonWidth: MediaQuery.of(context).size.width/2 - 36
              ),
            ),
            SizedBox(width: 24,),
            GestureDetector(
              onTap: (){
                uploadQuestionData();
              },
              child: blueButtom(
                  context: context,
                  label :"Adicionar",
                  buttonWidth: MediaQuery.of(context).size.width/2 - 36
              ),
            ),
          ],),
          SizedBox(height: 60,)

        ],),
      ),
    ),
    );

  }
}
