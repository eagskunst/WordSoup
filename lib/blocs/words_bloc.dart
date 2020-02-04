import 'dart:async';
import 'dart:convert';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_soup/models/gameboard_state.dart';
import 'package:word_soup/models/words_mappings.dart';
import 'package:word_soup/utils/base/selection_event.dart';
import 'package:word_soup/utils/base/word_direction.dart';
import 'package:word_soup/utils/color_generator.dart';
import 'package:word_soup/utils/constants.dart';
import 'package:word_soup/utils/widgets/soup_word.dart';
import 'package:word_soup/utils/widgets/word_model.dart';
import 'package:word_soup/utils/word_generator.dart';

class WordsBloc implements Bloc {

  int tableSize;
  var generating = false;
  String userName;
  final filledIndexes = Map<int, String>();
  final _wordIndexesString = List<String>();
  final addedWords = List<String>();
  final wordsDirections = List<WordDirection>();
  final _userFoundWords = List<String>();
  final _userFoundWordsIndices = List<int>();
  final themesIntegers = List<int>();
  final List<int> wordsColors = ColorGenerator().getColors();
  final filledIndexesColors = Map<int, int>();

  var unlockWordEnable = true;

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
    _userFoundWordsIndices.clear();
    _wordIndexesString.clear();
    unlockWordEnable = true;
    filledIndexesColors.clear();
    cleanWordsSink();
    this.tableSize = tableSize;
  }

  void cleanWordsSink() => _wordsSink.add(null);

  Future<void> generateWords(final int tableSize, final int wordsNumber, final int level) async{
    if(generating) return;
    if(themesIntegers.isEmpty){
      _generateThemesIntegers();
    }
    _restartBoard(tableSize);
    for(var i = 0; i < wordsNumber; i++){
      final generator = WordGenerator(
        WordsMappings(filledIndexes: filledIndexes,
          addedWords: addedWords,
          wordsDirections: wordsDirections,
          tableSize: tableSize,
          theme: themesIntegers[level-1]
        )
      );
      final info = await generator.generateWordInfo();
      final initialPosition = info.initialPosition;
      final direction = info.direction;
      final backwards = info.backwards;
      final word = info.word;

      var changingPos = initialPosition;
      print("Iterator: $i, $info");
      final buffer = StringBuffer();

      switch(direction){
        case WordDirection.Horizontal: {
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            i + 1 == word.length ? buffer.write(changingPos) : buffer.write('$changingPos-');
            backwards ? changingPos -- : changingPos++;
          }
          break;
        }
        case WordDirection.Vertical:
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            i + 1 == word.length ? buffer.write(changingPos) : buffer.write('$changingPos-');
            backwards ? changingPos -=tableSize : changingPos+=tableSize;
          }
          break;
        case WordDirection.Diagonal:
          if(changingPos == -1) break;
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            i + 1 == word.length ? buffer.write(changingPos) : buffer.write('$changingPos-');
            changingPos = backwards ? (changingPos - tableSize) - 1 :  (changingPos + tableSize) + 1;
          }
          break;
      }
      if(initialPosition != -1){
        addedWords.add(word.toUpperCase());
        wordsDirections.add(direction);
        _wordIndexesString.add(buffer.toString());
      }
    }
    final sentence = await createSentence();
    _wordsSink.add(sentence);
    generating = false;
  }

  Future<void> generateWordsFromSavedState(final GameBoardState state) async{
    if(generating) return;
    print(state);
    generating = true;
    this.userName = state.userName;
    _restartBoard(state.tableSize);
    unlockWordEnable = state.unlockWordEnable;
    if(themesIntegers.isNotEmpty)
      themesIntegers.clear();
    themesIntegers.addAll(state.themesIntegers);
    if(wordsColors.isNotEmpty)
      wordsColors.clear();
    wordsColors.addAll(state.wordsColors);
    filledIndexesColors.addAll(state.filledIndexesColors);
    filledIndexes.addAll(state.filledIndexes);
    _wordIndexesString.addAll(state.wordIndexesString);
    addedWords.addAll(state.addedWords);
    wordsDirections.addAll(state.wordsDirections);
    _userFoundWords.addAll(state.userFoundWords);
    _userFoundWordsIndices.addAll(state.userFoundWordsIndices);
    final sentence = await createSentence();
    _wordsSink.add(sentence);
    generating = false;
  }

  Future<String> createSentence(){
    final buffer = StringBuffer();
    for(var i = 0;i<tableSize * tableSize;i++){
      if(filledIndexes[i] != null){
        buffer.write(filledIndexes[i]);
      }
      else{
        buffer.write(WordPair.random().first[0].toUpperCase());
      }
    }
    print("Words in soup: $addedWords");
    return Future.value(buffer.toString());
  }

  @override
  void dispose() async{
    await _createWordsController.close();
    await _userSelectionStreamController.close();
  }

  void clearUserSelection() => _userSelectionSink.add(SelectionEvent.ClearSelection);

  void checkUserSelection() => _userSelectionSink.add(SelectionEvent.CheckSelection);

  void triggerLevelComplete() => _userSelectionSink.add(SelectionEvent.LevelCompleteSelection);

  List<SoupWord> createSoupWordsWidget() => addedWords.map((word) => SoupWord(
      model: WordModel(word, _userFoundWords.contains(word) ? Colors.indigo : Colors.white)
      )).toList(growable: false);

  void addUserFoundWord(String word, List<int> indices) {
    _userFoundWords.add(word);
    _userFoundWordsIndices.addAll(indices);
    for(final int index in indices){
      filledIndexesColors[index] = wordsColors[0];
    }
    wordsColors.removeAt(0);
  }

  List<String> getUserFoundWords() => _userFoundWords.toList(growable: false);

  List<int> getUserFoundWordsIndices() => _userFoundWordsIndices.toList(growable: false);

  List<int> getNotFoundWordIndexes() {
    List<int> indexes;
    for(int i = 0; i< _wordIndexesString.length; i++){
      indexes = _wordIndexesString[i].split('-').map( (n) => int.parse(n)).toList(growable: false);
      final buffer = StringBuffer();
      indexes.forEach((i) => buffer.write(filledIndexes[i]));
      print("Buffer word writed: $buffer");
      if(!_userFoundWords.contains(buffer.toString())){
        return indexes;
      }
    }
    return List<int>();
  }

  void _generateThemesIntegers(){
    final themeList = [1,2,3,4,5,6,7]
        ..shuffle();
    themesIntegers.addAll(themeList);
  }

  Color getLetterColorByIndex(final int index) => filledIndexesColors.containsKey(index) ? Color(filledIndexesColors[index]) : Color(wordsColors[0]);

  Future<void> saveGameBoardData(int level) async {
    final currentState = GameBoardState(level, tableSize, this.userName, filledIndexes, _wordIndexesString,
        addedWords, wordsDirections,_userFoundWords, _userFoundWordsIndices, this.themesIntegers, this.wordsColors,
        this.filledIndexesColors, unlockWordEnable);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.GAME_BOARD_STATE_KEY, jsonEncode(currentState));
  }

}