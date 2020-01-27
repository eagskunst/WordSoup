class BoardData {
  final double maxCrossAxisExtent;
  final int wordsNumber;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const BoardData(this.maxCrossAxisExtent, this.wordsNumber, [this.mainAxisSpacing = 5, this.crossAxisSpacing = 5]);

  static const BOARD_MAP = {
    7: BoardData(75, 6, 5, 10),
    8: BoardData(35, 8),
    9: BoardData(32, 10),
    10: BoardData(30, 12),
    11: BoardData(26, 14),
    12: BoardData(24, 16),
  };
}