import 'package:flutter/cupertino.dart';
import 'package:word_soup/utils/base/word_direction.dart';

class WordsMappings {
  final Map<int, String> filledIndexes;
  final List<String> addedWords;
  final List<WordDirection> wordsDirections;
  final int tableSize;

  WordsMappings({@required this.filledIndexes, @required this.addedWords, @required this.wordsDirections,
    @required this.tableSize});
}