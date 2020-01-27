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

  void restartBoard(final int tableSize){
    generating = true;
    addedWords.clear();
    filledIndexes.clear();
    wordsDirections.clear();
    wordsSink.add(null);
    this.tableSize = tableSize;
  }

  Future<void> generateWords(final int tableSize) async{
    if(generating) return;
    restartBoard(tableSize);
    final random = Random();
    for(var i = 0; i < tableSize; i++){ /*i < tableSize*/
      final direction = await _getWordDirection(random);
      final backwards = random.nextInt(2) == 1;
      final word = await _generateRandomWord(backwards, direction);
      final initialPosition = await _generateInitialPosition(
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
          break;
        }
        case WordDirection.Vertical:
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            backwards ? changingPos -=tableSize : changingPos+=tableSize;
          }
          break;
        case WordDirection.Diagonal:
          for(var i = 0; i < word.length; i++){
            filledIndexes[changingPos] = word[i];
            changingPos = backwards ? (changingPos - tableSize) - 1 :  (changingPos - tableSize) + 1;
          }
          break;
      }

      addedWords.add(word.toUpperCase());
      wordsDirections.add(direction);
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

  int _calculateAmountOfDirection(final WordDirection direction) =>
      wordsDirections.fold(0, (acc, dir) => dir == direction ? acc++ : acc);

  Future<WordDirection> _getWordDirection(final Random random){
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
            return Future.value(WordDirection.Horizontal);
          }
          break;
        case 1:
          if(amountVer != tableSize / 2) {
            keepLooking = false;
            return Future.value(WordDirection.Vertical);
          }
          break;
        case 2:
          if(amountDiag != tableSize / 2) {
            keepLooking = false;
            return Future.value(WordDirection.Diagonal);
          }
          break;
      }
    }
    return Future.value(WordDirection.Horizontal);
  }

  Future<String> _generateRandomWord(final bool backwards, final WordDirection direction){
    var keepLooking = true;
    var word = "";
    while(keepLooking){
      word = WordPair.random().first;
      if(!addedWords.contains(word) && word.length <= tableSize){
        for(var i = 0; i < tableSize * tableSize; i++){
          keepLooking = _checkIfCanAddWord(
            word: word, backwards: backwards, direction: direction, position: i
          );
          if(!keepLooking){
            String to;
            if(direction == WordDirection.Horizontal){
              to = "${i+word.length}";
            }
            else if(direction == WordDirection.Vertical){
              to = "${ i + ( (word.length - 1) * tableSize)}";
            }
            print("The word $word can be added from:$i to:$to");
            break;
          }
        }
      }
    }
    return Future.value(word);
  }

  bool _checkIfCanAddWord({final String word, final bool backwards, final int position, final WordDirection direction}){
    var keepLooking = false;
    var mutablePos = position;
    switch(direction){

      case WordDirection.Horizontal:

        for(var i = 0; i<word.length && !keepLooking;i++){
          final canAdd = backwards ? mutablePos >= 0 : mutablePos < (tableSize * tableSize);
          if( (filledIndexes.containsKey(mutablePos) && filledIndexes[mutablePos] != word[i]))
            keepLooking = true;
          else if(!canAdd)
            keepLooking = true;
          else if(exceedRow(mutablePos, position))
            keepLooking = true;
          backwards ? mutablePos-- : mutablePos++;
        }
        break;
      case WordDirection.Vertical:
        for(var i = 0; i<word.length && !keepLooking;i++){
          final canAdd = backwards ? mutablePos >= 0 :mutablePos < (tableSize * tableSize);
          if(filledIndexes.containsKey(mutablePos) && filledIndexes[mutablePos] != word[i])
            keepLooking = true;
          else if(!canAdd)
            keepLooking = true;
          backwards ? mutablePos-=tableSize : mutablePos+=tableSize;
        }
        break;
      case WordDirection.Diagonal:
        for(var i = 0; i<word.length && !keepLooking;i++){
          if(filledIndexes.containsKey(mutablePos) && filledIndexes[mutablePos] != word[i])
            keepLooking = true;
          mutablePos = backwards ? (mutablePos - tableSize) - 1 :  (mutablePos - tableSize) + 1;
        }
        break;
    }

    return keepLooking;
  }

  int _getMaxPosForRow(final int position){
    final currentRow = position ~/ tableSize;
    return (currentRow * tableSize) + tableSize - 1;
  }

  int _getMinPosForRow(final int position){
    final currentRow = position ~/ tableSize;
    return currentRow * tableSize;
  }

  bool exceedRow(final int currentPos,final int originalPos) => currentPos > _getMaxPosForRow(originalPos) || currentPos < _getMinPosForRow(originalPos);

  Future<int> _generateInitialPosition({final String word, final bool backwards, final WordDirection direction}){
    final rand = Random();

    switch(direction){
      case WordDirection.Horizontal: {
        if(word.length == tableSize){
          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = rand.nextInt(2) == 1 ? ( (rand.nextInt(tableSize) * tableSize) + tableSize - 1 ) : rand.nextInt(tableSize) * tableSize;
            keepLooking = _checkIfCanAddWord(
              word: word,
              backwards: backwards,
              position: pos,
              direction: direction
            );
          }
          return Future.value(pos);
        }
        else {
          final limitStarts = (tableSize - word.length) + 1;
          final possiblePositions = List<int>();

          for(var i = 0; i < tableSize;i++) {
            for(var j = word.length - (limitStarts - 1); j < tableSize; j++){
              possiblePositions.add( (tableSize * i) + j);
            }
            for(var j = limitStarts - 1; j>=0; j--){
              possiblePositions.add( (tableSize * i) + j);
            }
          }

          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = possiblePositions.elementAt(rand.nextInt(possiblePositions.length));
            possiblePositions.remove(pos);
            keepLooking = _checkIfCanAddWord(
              word: word,
              backwards: backwards,
              position: pos,
              direction: direction
            );
          }
          return Future.value(pos);
        }
        break;
      }
      case WordDirection.Vertical:{
        if(word.length == tableSize){
          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = rand.nextInt(2) == 1 ? ( rand.nextInt(tableSize) + (tableSize * (tableSize - 1)) ) : rand.nextInt(tableSize);
            keepLooking = _checkIfCanAddWord(
              word: word,
              backwards: backwards,
              position: pos,
              direction: direction
            );
          }
          return Future.value(pos);
        }
        else {
          final limitStarts = (tableSize - word.length) + 1;
          final possiblePositions = List<int>();

          for(var i = 0; i < limitStarts;i++) {
            for(var j = ( tableSize * (tableSize - i) ) - 1; j >= ( tableSize * (tableSize - i - 1) ); j--){
              possiblePositions.add(j);
            }
            for(var j = tableSize * i; j < (tableSize * (i + 1) ); j++){
              possiblePositions.add(j);
            }
          }

          var keepLooking = true;
          int pos = -1;
          while(keepLooking){
            pos = possiblePositions.elementAt(rand.nextInt(possiblePositions.length));
            possiblePositions.remove(pos);
            keepLooking = _checkIfCanAddWord(
                word: word,
                backwards: backwards,
                position: pos,
                direction: direction
            );
          }
          return Future.value(pos);
        }
        break;
      }
      case WordDirection.Diagonal: {
        final possiblePositionsBackwards = [(tableSize * tableSize) - 1];
        final possiblePositionsForwards = [(tableSize * (tableSize - 1))];
        final offsetColumns = List<int>();
        for(var i = 0; i < tableSize; i++){
          offsetColumns.add(i * tableSize);
          offsetColumns.add( (i * tableSize) + tableSize - 1);
        }

        if(word.length != tableSize){
          //Create positions going backwards:
          for(var i = tableSize * tableSize - 1;i>=0;i--){ //Can be optimized looking for max row to use based on word length
            final filteredList =  offsetColumns.where( (i) => i%tableSize == 0).toList(growable: false);
            final result = finalPositionFromBackwards(i, 1, word.length, filteredList);
            if(result < tableSize * tableSize && result >= 0)
              possiblePositionsBackwards.add(i);
          }
          for(var i = 0;i < tableSize * tableSize;i++){ //Can be optimized looking for max row to use based on word length
            final filteredList = offsetColumns.where( (i) => i%tableSize != 0).toList(growable: false);
            final result = finalPositionFromForward(i, 1, word.length, filteredList);
            if(result < tableSize * tableSize && result >= 0)
              possiblePositionsForwards.add(i);
          }
        }
        final listToUse = backwards ? possiblePositionsBackwards : possiblePositionsForwards;
        while(listToUse.isNotEmpty){
          int posToCheck;
          posToCheck = listToUse.elementAt(rand.nextInt(listToUse.length));
          listToUse.remove(posToCheck);

          final keepLooking = _checkIfCanAddWord(
            word: word, backwards: backwards, position: posToCheck, direction: direction
          );
          if(!keepLooking) {
            return Future.value(posToCheck);
          }
        }
        break;
      }
    }

    return Future.value(-1);
  }

  int finalPositionFromBackwards(final position, final int acc, final int wordLength, final List<int> offsetColumns){
    if(acc == wordLength)
      return position;
    else if(offsetColumns.contains(position))
      return -1;
    else
      return finalPositionFromBackwards((position - tableSize) - 1, acc+1, wordLength, offsetColumns);
  }

  int finalPositionFromForward(final position, final int acc, final int wordLength, final List<int> offsetColumns){
    if(position == 34)
      print("Debug");
    if(acc == wordLength)
      return position;
    else if(offsetColumns.contains(position))
      return tableSize * tableSize + 1;
    else
      return finalPositionFromForward((position - tableSize) + 1, acc+1, wordLength, offsetColumns);
  }

  @override
  void dispose() async{
    await createWordsController.close();
  }

}