import 'package:flutter/foundation.dart';

class BoardData {
  final double gridHeight;
  final int wordsNumber;
  final int level;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const BoardData(this.gridHeight, this.wordsNumber, this.level, [this.mainAxisSpacing = 5, this.crossAxisSpacing = 5]);

  static const BOARD_MAP = {
    7: BoardData(410, 6, 1, 5, 10),
    8: BoardData(kIsWeb ? 410 : 445, 8, 2),
    9: BoardData(kIsWeb ? 410 : 443, 10, 3),
    10: BoardData(kIsWeb ? 410 : 440, 12, 4),
    11: BoardData(kIsWeb ? 410 : 437, 14, 5),
    12: BoardData(kIsWeb ? 410 : 435, 16, 6),
  };
}