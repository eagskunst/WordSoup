import 'dart:async';

import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:english_words/english_words.dart';
import 'package:word_soup/models/words_mappings.dart';
import 'package:word_soup/utils/base/word_direction.dart';
import 'package:word_soup/utils/word_generator.dart';

class WordsBloc implements Bloc{
  int tableSize;
  var generating = false;
  final filledIndexes = Map<int, String>();
  final addedWords = List<String>();
  final wordsDirections = List<WordDirection>();

  WordsBloc();

  StreamController<String> createWordsController = StreamController();
  Stream<String> get wordsStream => createWordsController.stream;
  StreamSink<String> get wordsSink => createWordsController.sink;

  void restartBoard(final int tableSize){
    generating = true;
    addedWords.clear();
    filledIndexes.clear();
    wordsDirections.clear();
    wordsSink.add(null);
    this.tableSize = tableSize;
  }

  Future<void> generateWords(final int tableSize, final int wordsNumber) async{
    if(generating) return;
    restartBoard(tableSize);
    for(var i = 0; i < wordsNumber; i++){ /*i < tableSize*/
      final generator = WordGenerator(
        WordsMappings(filledIndexes: filledIndexes,
            addedWords: addedWords,
            wordsDirections: wordsDirections,
            tableSize: tableSize)
      );
      final info = await generator.generateWordInfo();
      final initialPosition = info.initialPosition;
      final direction = info.direction;
      final backwards = info.backwards;
      final word = info.word;

      var changingPos = initialPosition;
      print("Iterator: $i, $info");

      switch(direction){
        case WordDirection.Horizontal: {
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            backwards ? changingPos -- : changingPos++;
          }
          break;
        }
        case WordDirection.Vertical:
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            backwards ? changingPos -=tableSize : changingPos+=tableSize;
          }
          break;
        case WordDirection.Diagonal:
          if(changingPos == -1) break;
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            changingPos = backwards ? (changingPos - tableSize) - 1 :  (changingPos + tableSize) + 1;
          }
          break;
      }
      if(initialPosition != -1){
        addedWords.add(word.toUpperCase());
        wordsDirections.add(direction);
      }
    }
    final buffer = StringBuffer();
    for(var i = 0;i<tableSize * tableSize;i++){
      if(filledIndexes[i] != null){
        buffer.write(filledIndexes[i].toUpperCase());
      }
      else{
        buffer.write(WordPair.random().first[0]);
      }
    }
    print("Words in soup: $addedWords");
    wordsSink.add(buffer.toString());
    generating = false;
  }

  @override
  void dispose() async{
    await createWordsController.close();
  }

}