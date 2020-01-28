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
      children: words,
    );
  }


}