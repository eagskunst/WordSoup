// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameboard_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameBoardState _$GameBoardStateFromJson(Map<String, dynamic> json) {
  return GameBoardState(
    json['level'] as int,
    json['tableSize'] as int,
    json['userName'] as String,
    (json['filledIndexes'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e as String),
    ),
    (json['wordIndexesString'] as List)?.map((e) => e as String)?.toList(),
    (json['addedWords'] as List)?.map((e) => e as String)?.toList(),
    (json['wordsDirections'] as List)
        ?.map((e) => _$enumDecodeNullable(_$WordDirectionEnumMap, e))
        ?.toList(),
    (json['userFoundWords'] as List)?.map((e) => e as String)?.toList(),
    (json['userFoundWordsIndices'] as List)?.map((e) => e as int)?.toList(),
    (json['themesIntegers'] as List)?.map((e) => e as int)?.toList(),
    (json['wordsColors'] as List)?.map((e) => e as int)?.toList(),
    (json['filledIndexesColors'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e as int),
    ),
    json['unlockWordEnable'] as bool,
  );
}

Map<String, dynamic> _$GameBoardStateToJson(GameBoardState instance) =>
    <String, dynamic>{
      'level': instance.level,
      'tableSize': instance.tableSize,
      'userName': instance.userName,
      'filledIndexes':
          instance.filledIndexes?.map((k, e) => MapEntry(k.toString(), e)),
      'wordIndexesString': instance.wordIndexesString,
      'addedWords': instance.addedWords,
      'wordsDirections': instance.wordsDirections
          ?.map((e) => _$WordDirectionEnumMap[e])
          ?.toList(),
      'userFoundWords': instance.userFoundWords,
      'userFoundWordsIndices': instance.userFoundWordsIndices,
      'themesIntegers': instance.themesIntegers,
      'wordsColors': instance.wordsColors,
      'filledIndexesColors': instance.filledIndexesColors
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'unlockWordEnable': instance.unlockWordEnable,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$WordDirectionEnumMap = {
  WordDirection.Horizontal: 'Horizontal',
  WordDirection.Vertical: 'Vertical',
  WordDirection.Diagonal: 'Diagonal',
};
