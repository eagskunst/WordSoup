import 'package:flutter/cupertino.dart';
import 'package:word_soup/utils/base/word_direction.dart';

class WordInfo {
  final String word;
  final WordDirection direction;
  final bool backwards;
  final int initialPosition;

  WordInfo({@required this.word, @required this.direction, @required this.backwards, @required this.initialPosition});

  static WordInfo noWordsLeft() => WordInfo(word: null, direction: null, backwards: null, initialPosition: null);

  @override
  String toString() => "WordInfo(word: $word, direction: $direction, backwards: $backwards, initialPosition: $initialPosition)";
}