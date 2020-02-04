import 'dart:math';

import 'package:word_soup/models/word_info.dart';
import 'package:word_soup/models/words_mappings.dart';
import 'package:word_soup/utils/word_theme_generator.dart';

import 'base/word_direction.dart';

typedef ChangePosition = int Function(int);

class WordGenerator {
  final WordsMappings mappings;

  Map<int, String> get filledIndexes => mappings.filledIndexes;
  List<String> get addedWords => mappings.addedWords;
  int get tableSize => mappings.tableSize;
  List<WordDirection> get wordsDirections => mappings.wordsDirections;

  WordGenerator(this.mappings);

  Future<WordInfo> generateWordInfo() async{
    final random = Random();
    final direction = await _getWordDirection(random);
    final backwards = random.nextInt(2) == 1;
    final word = await _generateRandomWord(backwards, direction);
    final initialPosition = await _generateInitialPosition(
        word: word,
        backwards: backwards,
        direction: direction
    );
    if(initialPosition != -1) return Future.value(
        WordInfo(
          word: word,
          direction: direction,
          backwards: backwards,
          initialPosition: initialPosition
        )
    );
    else return await _generateWithFallback(random);
  }

  Future<WordInfo> _generateWithFallback(final Random random) async{
    var initialPosition = -1;
    WordInfo info;
    while(initialPosition == -1){
      final direction = await _getWordDirection(random, true);
      final backwards = random.nextInt(2) == 1;
      final word = await _generateRandomWord(backwards, direction);
      initialPosition = await _generateInitialPosition(
          word: word,
          backwards: backwards,
          direction: direction
      );

      if(initialPosition != -1){
        info = WordInfo(
            word: word,
            direction: direction,
            backwards: backwards,
            initialPosition: initialPosition
        );
      }
    }
    return Future.value(info);
  }

  Future<WordDirection> _getWordDirection(final Random random, [bool isFallback = false]){
    int amountHor = _calculateAmountOfDirection(WordDirection.Horizontal);
    int amountVer = _calculateAmountOfDirection(WordDirection.Vertical);
    int amountDiag = _calculateAmountOfDirection(WordDirection.Diagonal);

    var keepLooking = true;
    while(keepLooking){
      int generatedNumber = random.nextInt(3);
      switch(generatedNumber){
        case 0:
          if(isFallback) return Future.value(WordDirection.Horizontal);
          if(amountHor != tableSize / 2) {
            keepLooking = false;
            return Future.value(WordDirection.Horizontal);
          }
          break;
        case 1:
          if(isFallback) return Future.value(WordDirection.Vertical);
          if(amountVer != tableSize / 2) {
            keepLooking = false;
            return Future.value(WordDirection.Vertical);
          }
          break;
        case 2:
          if(isFallback) return Future.value(WordDirection.Diagonal);
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
      word = WordThemeGenerator().getWords(
          theme: mappings.theme,
          arraySize: WordThemeGenerator.maxWords)
          .first;
      if(!addedWords.contains(word) && word.length <= tableSize){
        for(var i = 0; i < tableSize * tableSize; i++){
          keepLooking = _checkIfCanAddWord(
              word: word, backwards: backwards, direction: direction, position: i,
            sumBy: _getSumOfDirection(backwards, direction)
          );
          if(!keepLooking){
            String to;
            if(direction == WordDirection.Horizontal){
              to = "${i+word.length}";
            }
            else if(direction == WordDirection.Vertical){
              to = "${ i + ( (word.length - 1) * tableSize)}";
            }
            else{
              final finalPos = backwards ? finalPositionFromBackwards(i, 1, word.length, []) : finalPositionFromForward(i, 1, word.length, []);
              to = finalPos.toString();
            }
            print("The word $word can be added from:$i to:$to");
            break;
          }
        }
      }
    }
    return Future.value(word);
  }

  ChangePosition _getSumOfDirection(bool backwards, WordDirection direction){
    switch(direction){
      case WordDirection.Horizontal:
        return (final position) => backwards ? position-1 : position+1;
      case WordDirection.Vertical:
        return (final position) => backwards ? position-tableSize : position+tableSize;
      default:
        return (final position) => backwards ? (position - tableSize) - 1 :  (position + tableSize) + 1;
    }
  }


  bool _checkIfCanAddWord({final String word, final bool backwards, final int position,
    final WordDirection direction, ChangePosition sumBy}){
    var keepLooking = false;
    var mutablePos = position;

    for(var i = 0; i<word.length && !keepLooking;i++){
      final canAdd = backwards ? mutablePos >= 0 : mutablePos < (tableSize * tableSize);
      if( (filledIndexes.containsKey(mutablePos) && filledIndexes[mutablePos] != word[i]))
        keepLooking = true;
      else if(!canAdd)
        keepLooking = true;
      else if(direction == WordDirection.Horizontal && exceedRow(mutablePos, position))
        keepLooking = true;
      mutablePos = sumBy(mutablePos);
    }
    return keepLooking;
  }


  int _calculateAmountOfDirection(final WordDirection direction) =>
      mappings.wordsDirections.fold(0, (acc, dir) => dir == direction ? acc++ : acc);


  bool exceedRow(final int currentPos,final int originalPos) => currentPos > _getMaxPosForRow(originalPos)
      || currentPos < _getMinPosForRow(originalPos);

  int _getMinPosForRow(final int position){
    final currentRow = position ~/ mappings.tableSize;
    return currentRow * mappings.tableSize;
  }

  int _getMaxPosForRow(final int position){
    final currentRow = position ~/ mappings.tableSize;
    return (currentRow * mappings.tableSize) + mappings.tableSize - 1;
  }

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
                direction: direction,
                sumBy: _getSumOfDirection(backwards, direction)
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
          while(keepLooking && possiblePositions.isNotEmpty){
            pos = possiblePositions.elementAt(rand.nextInt(possiblePositions.length));
            possiblePositions.remove(pos);
            keepLooking = _checkIfCanAddWord(
                word: word,
                backwards: backwards,
                position: pos,
                direction: direction,
                sumBy: _getSumOfDirection(backwards, direction)
            );
          }
          if(!keepLooking) return Future.value(pos);
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
                direction: direction,
                sumBy: _getSumOfDirection(backwards, direction)
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
          while(keepLooking && possiblePositions.isNotEmpty){
            pos = possiblePositions.elementAt(rand.nextInt(possiblePositions.length));
            possiblePositions.remove(pos);
            keepLooking = _checkIfCanAddWord(
                word: word,
                backwards: backwards,
                position: pos,
                direction: direction,
                sumBy: _getSumOfDirection(backwards, direction)
            );
          }
          if(!keepLooking) return Future.value(pos);
        }
        break;
      }
      case WordDirection.Diagonal: {
        final possiblePositionsBackwards = [(tableSize * tableSize) - 1];
        final possiblePositionsForwards = [0];
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
              word: word, backwards: backwards, position: posToCheck, direction: direction,
              sumBy: _getSumOfDirection(backwards, direction)
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
    if(acc == wordLength)
      return position;
    else if(offsetColumns.contains(position))
      return tableSize * tableSize + 1;
    else
      return finalPositionFromForward((position + tableSize) + 1, acc+1, wordLength, offsetColumns);
  }

}