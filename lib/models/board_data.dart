class BoardData {
  final double gridHeight;
  final int wordsNumber;
  final int level;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const BoardData(this.gridHeight, this.wordsNumber, this.level, [this.mainAxisSpacing = 5, this.crossAxisSpacing = 5]);

  static const BOARD_MAP = {
    7: BoardData(410, 6, 1, 5, 10),
    8: BoardData(445, 8, 2),
    9: BoardData(443, 10, 3),
    10: BoardData(440, 12, 4),
    11: BoardData(437, 14, 5),
    12: BoardData(435, 16, 6),
  };
}