<<<<<<< HEAD
import 'package:flutter/foundation.dart';
=======
import 'dart:ui';
>>>>>>> master

class BoardData {
  final double gridHeight;
  final int wordsNumber;
  final int level;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const BoardData(this.gridHeight, this.wordsNumber, this.level, [this.mainAxisSpacing = 5, this.crossAxisSpacing = 5]);

  static const BOARD_MAP = {
    7: BoardData(710, 6, 1, 5, 10),
    8: BoardData(710, 8, 2),
    9: BoardData(710, 10, 3),
    10: BoardData(710, 12, 4),
    11: BoardData(710, 14, 5),
    12: BoardData(710, 16, 6),
  };

  static const double screenPercentage = .63;

  static Map<int, BoardData> responsiveBoardMap(final Size size) => {
    7: BoardData(size.height * screenPercentage, 6, 1, 5, 10),
    8: BoardData(size.height * screenPercentage, 8, 2),
    9: BoardData(size.height * screenPercentage, 10, 3),
    10: BoardData(size.height * screenPercentage, 12, 4),
    11: BoardData(size.height * screenPercentage, 14, 5),
    12: BoardData(size.height * screenPercentage, 16, 6),
  };
}