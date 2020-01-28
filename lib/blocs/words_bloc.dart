import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/models/words_mappings.dart';
import 'package:word_soup/utils/base/selection_event.dart';
import 'package:word_soup/utils/base/word_direction.dart';
import 'package:word_soup/utils/widgets/soup_word.dart';
import 'package:word_soup/utils/widgets/word_model.dart';
import 'package:word_soup/utils/word_generator.dart';

class WordsBloc implements Bloc{
  int tableSize;
  var generating = false;
  final filledIndexes = Map<int, String>();
  final addedWords = List<String>();
  final wordsDirections = List<WordDirection>();
  final _userFoundWords = List<String>();
  final _userFoundWordsIndices = List<int>();


  WordsBloc();

  StreamController<String> _createWordsController = StreamController();
  Stream<String> get wordsStream => _createWordsController.stream;
  StreamSink<String> get _wordsSink => _createWordsController.sink;
  StreamController<SelectionEvent> _userSelectionStreamController = StreamController.broadcast();
  Stream<SelectionEvent> get userSelectionStream => _userSelectionStreamController.stream;
  StreamSink<SelectionEvent> get _userSelectionSink=> _userSelectionStreamController.sink;

  void _restartBoard(final int tableSize){
    generating = true;
    addedWords.clear();
    filledIndexes.clear();
    wordsDirections.clear();
    _userFoundWords.clear();
    cleanWordsSink();
    this.tableSize = tableSize;
  }

  void cleanWordsSink() => _wordsSink.add(null);

  Future<void> generateWords(final int tableSize, final int wordsNumber) async{
    if(generating) return;
    _restartBoard(tableSize);
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
    _wordsSink.add(buffer.toString());
    generating = false;
  }

  @override
  void dispose() async{
    await _createWordsController.close();
    await _userSelectionStreamController.close();
  }

  void clearUserSelection() => _userSelectionSink.add(SelectionEvent.ClearSelection);


  void checkUserSelection() => _userSelectionSink.add(SelectionEvent.CheckSelection);

  List<SoupWord> createSoupWordsWidget() => addedWords.map((word) => SoupWord(
      model: WordModel(word, _userFoundWords.contains(word) ? Colors.indigo : Colors.white)
      )).toList(growable: false);

  void addUserFoundWord(String word, List<int> indices) {
    _userFoundWords.add(word);
    _userFoundWordsIndices.addAll(indices);
  }

  List<String> getUserFoundWords() => _userFoundWords.toList(growable: false);

  List<int> getUserFoundWordsIndices() => _userFoundWordsIndices.toList(growable: false);

}