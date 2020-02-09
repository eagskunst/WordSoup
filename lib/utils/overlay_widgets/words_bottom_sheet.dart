import 'package:flutter/material.dart';
import 'package:word_soup/utils/widgets/soup_word.dart';

class WordsBottomSheet extends StatelessWidget{
  final List<SoupWord> words;

  const WordsBottomSheet({Key key, this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.start,
      children: [
        FittedBox(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              'Primeras letras de las palabras en el tablero',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.start,
          children: words,
        )
      ],
    );
  }


}