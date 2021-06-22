import 'package:flutter/material.dart';
class OptionTile extends StatefulWidget {
  final String option, descricao, respostaCorreta, optionSelected;
  OptionTile({@required this.optionSelected, @required this.respostaCorreta, @required  this.descricao, @required this.option});


  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color:widget.descricao== widget.optionSelected ? widget.optionSelected == widget.respostaCorreta ?
              Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7) : Colors.grey , width: 1.4),
              borderRadius: BorderRadius.circular(30),
            ),
           alignment: Alignment.center,
           child: Text("${widget.option}", style: TextStyle(
             color: widget.optionSelected == widget.descricao ?
                 widget.respostaCorreta == widget.optionSelected ?
                 Colors.green.withOpacity(0.7) : Colors.red: Colors.grey
           )),
          ),
          SizedBox(width: 8 ,),
          Text(widget.descricao , style: TextStyle(fontSize: 16 , color: Colors.black54),)
        ],
      ),
    );
  }
}

