import 'dart:core';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:word_soup/utils/base/word_direction.dart';

part 'gameboard_state.g.dart';

@JsonSerializable()
class GameBoardState {

  final int level;
  final int tableSize;
  final String userName;
  final Map<int, String> filledIndexes;
  final List<String> wordIndexesString;
  final List<String> addedWords;
  final List<WordDirection> wordsDirections;
  final List<String> userFoundWords;
  final List<int> userFoundWordsIndices;
  final List<int> themesIntegers;
  final List<int> wordsColors;
  final Map<int, int> filledIndexesColors;
  final bool unlockWordEnable;

  GameBoardState(this.level, this.tableSize, this.userName, this.filledIndexes, this.wordIndexesString, this.addedWords,
      this.wordsDirections, this.userFoundWords, this.userFoundWordsIndices, this.themesIntegers, this.wordsColors,
      this.filledIndexesColors, this.unlockWordEnable);

  factory GameBoardState.fromJson(Map<String, dynamic> json) => _$GameBoardStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameBoardStateToJson(this);

  @override
  String toString() => 'GameBoardState(level: $level, tableSize: $tableSize, userName: $userName, filledIndexes: $filledIndexes, wordIndexesString: $wordIndexesString, addedWords: $addedWords, wordsDirections: $wordsDirections, userFoundWords: $userFoundWords, userFoundWordsIndices: $userFoundWordsIndices, themesIntegers: $themesIntegers, unlockWordEnable: $unlockWordEnable)';
}