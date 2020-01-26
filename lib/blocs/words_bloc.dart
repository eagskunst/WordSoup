import 'dart:async';

import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:english_words/english_words.dart';
import 'package:word_soup/utils/base/word_direction.dart';

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

  void _restartBoard(int tableSize){
    generating = true;
    addedWords.clear();
    filledIndexes.clear();
    wordsDirections.clear();
    this.tableSize = tableSize;
  }

  void generateWords(int tableSize) async{
    if(generating) return;
    _restartBoard(tableSize);
    final random = Random();
    for(var i = 0; i < 2; i++){ /*i < tableSize*/
      final direction = WordDirection.Vertical;/*_getWordDirection(random);*/
      final backwards = random.nextInt(2) == 1;
      final word = _generateRandomWord();
      final initialPosition = _generateInitialPosition(
          word: word,
          backwards: backwards,
          direction: direction
      );
      var changingPos = initialPosition;

      switch(direction){
        case WordDirection.Horizontal: {
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            backwards ? changingPos -- : changingPos++;
          }
          addedWords.add(word);
          wordsDirections.add(WordDirection.Horizontal);
          break;
        }
        case WordDirection.Vertical:
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            backwards ? changingPos -=tableSize : changingPos+=tableSize;
          }
          addedWords.add(word);
          wordsDirections.add(WordDirection.Horizontal);
          break;
        case WordDirection.Diagonal:
          break;
      }
    }
    final buffer = StringBuffer();
    for(var i = 0;i<tableSize * tableSize;i++){
      if(filledIndexes[i] != null){
        buffer.write(filledIndexes[i]);
      }
      else{
        buffer.write(WordPair.random().first[0]);
      }
    }
    wordsSink.add(buffer.toString());
    print("Words added: $addedWords");
    generating = false;
  }

  int _calculateAmountOfDirection(WordDirection direction) =>
      wordsDirections.fold(0, (acc, dir) => dir == direction ? acc++ : acc);

  WordDirection _getWordDirection(Random random){
    int amountHor = _calculateAmountOfDirection(WordDirection.Horizontal);
    int amountVer = _calculateAmountOfDirection(WordDirection.Vertical);
    int amountDiag = _calculateAmountOfDirection(WordDirection.Diagonal);
    var keepLooking = true;
    while(keepLooking){
      int generatedNumber = random.nextInt(3);
      switch(generatedNumber){
        case 0:
          if(amountHor != tableSize / 2) {
            keepLooking = false;
            return WordDirection.Horizontal;
          }
          break;
        case 1:
          if(amountVer != tableSize / 2) {
            keepLooking = false;
            return WordDirection.Vertical;
          }
          break;
        case 2:
          if(amountDiag != tableSize / 2) {
            keepLooking = false;
            return WordDirection.Diagonal;
          }
          break;
      }
    }
    return WordDirection.Horizontal;
  }

  String _generateRandomWord(){
    var keepLooking = true;
    while(keepLooking){
      final word = WordPair.random().first;
      if(!addedWords.contains(word) && word.length <= tableSize){
        keepLooking = false;
        return word;
      }
    }
    return "";
  }

  bool _checkIfCanAddWord({String word, bool backwards, int position, WordDirection direction}){
    var keepLooking = false;
    var mutablePos = position;
    switch(direction){

      case WordDirection.Horizontal:
        for(var i = 0; i<word.length;i++){
          if(filledIndexes.containsKey(mutablePos) && filledIndexes[mutablePos] != word[i])
            keepLooking = true;
          backwards ? mutablePos-- : mutablePos++;
        }
        break;
      case WordDirection.Vertical:
        for(var i = 0; i<word.length;i++){
          if(filledIndexes.containsKey(mutablePos) && filledIndexes[mutablePos] != word[i])
            keepLooking = true;
          backwards ? mutablePos-=tableSize : mutablePos+=tableSize;
        }
        break;
      case WordDirection.Diagonal:
        // TODO: Handle this case.
        break;
    }

    return keepLooking;
  }

  int _generateInitialPosition({String word, bool backwards, WordDirection direction}){
    final rand = Random();
    switch(direction){
      case WordDirection.Horizontal: {
        if(word.length == tableSize){
          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = backwards ? ( (rand.nextInt(tableSize) * tableSize) + tableSize - 1 ) : rand.nextInt(tableSize) * tableSize;
            keepLooking = _checkIfCanAddWord(
              word: word,
              backwards: backwards,
              position: pos,
              direction: direction
            );
          }
          return pos;
        }
        else {
          final limitStarts = (tableSize - word.length) + 1;
          final possiblePositions = List<int>();

          for(var i = 0; i < tableSize;i++) {
            if(backwards){
              for(var j = word.length - (limitStarts - 1); j < tableSize; j++){
                possiblePositions.add( (tableSize * i) + j);
              }
            }
            else{
              for(var j = limitStarts - 1; j>=0; j--){
                possiblePositions.add( (tableSize * i) + j);
              }
            }
          }

          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = possiblePositions.elementAt(rand.nextInt(possiblePositions.length));
            keepLooking = _checkIfCanAddWord(
              word: word,
              backwards: backwards,
              position: pos,
              direction: direction
            );
          }
          return pos;
        }
        break;
      }
      case WordDirection.Vertical:{
        if(word.length == tableSize){
          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = backwards ? ( rand.nextInt(tableSize) + (tableSize * (tableSize - 1)) ) : rand.nextInt(tableSize);
            keepLooking = _checkIfCanAddWord(
              word: word,
              backwards: backwards,
              position: pos,
              direction: direction
            );
          }
          return pos;
        }
        else {
          final limitStarts = (tableSize - word.length) + 1;
          final possiblePositions = List<int>();

          for(var i = 0; i < limitStarts;i++) {
            if(backwards){
              for(var j = ( tableSize * (tableSize - i) ) - 1; j >= ( tableSize * (tableSize - i - 1) ); j--){
                possiblePositions.add(j);
              }
            }
            else{
              for(var j = tableSize * i; j < (tableSize * (i + 1) ) - 1; j++){
                possiblePositions.add(j);
              }
            }
          }

          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = possiblePositions.elementAt(rand.nextInt(possiblePositions.length));
            keepLooking = _checkIfCanAddWord(
                word: word,
                backwards: backwards,
                position: pos,
                direction: direction
            );
          }
          return pos;
        }
        break;
      }
      case WordDirection.Diagonal:{

        break;
      }
    }

    return -1;
  }

  @override
  void dispose() async{
    await createWordsController.close();
  }

}