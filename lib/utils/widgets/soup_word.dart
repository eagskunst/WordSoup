import 'package:flutter/material.dart';
import 'package:word_soup/utils/widgets/word_model.dart';

class SoupWord extends StatelessWidget {

  final WordModel model;

  const SoupWord({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      width: 100,
      height: 45,
      decoration: BoxDecoration(
        color: model.color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.76),
            blurRadius: 0,
            spreadRadius: 0,
          )
        ],
       /*border: Border.all(
         color: Colors.grey.withOpacity(0.5),
         width: 0.5
       )*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(model.word[0],
            style: TextStyle(
              color: model.color == Colors.white ?  Colors.black : Colors.white,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}