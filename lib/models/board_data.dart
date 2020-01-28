class BoardData {
  final double gridHeight;
  final int wordsNumber;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const BoardData(this.gridHeight, this.wordsNumber, [this.mainAxisSpacing = 5, this.crossAxisSpacing = 5]);

  static const BOARD_MAP = {
    7: BoardData(410, 6, 5, 10),
    8: BoardData(445, 8),
    9: BoardData(443, 10),
    10: BoardData(440, 12),
    11: BoardData(437, 14),
    12: BoardData(435, 16),
  };
}