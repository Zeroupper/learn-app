// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VocabWord _$VocabWordFromJson(Map<String, dynamic> json) => _VocabWord(
  id: (json['id'] as num).toInt(),
  en: json['en'] as String,
  enAccepted:
      (json['en_accepted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  hu: (json['hu'] as List<dynamic>).map((e) => e as String).toList(),
  level: $enumDecode(_$CefrLevelEnumMap, json['level']),
  pos: json['pos'] as String? ?? '',
  exampleEn: json['example_en'] as String?,
  exampleHu: json['example_hu'] as String?,
);

Map<String, dynamic> _$VocabWordToJson(_VocabWord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'en': instance.en,
      'en_accepted': instance.enAccepted,
      'hu': instance.hu,
      'level': _$CefrLevelEnumMap[instance.level]!,
      'pos': instance.pos,
      'example_en': instance.exampleEn,
      'example_hu': instance.exampleHu,
    };

const _$CefrLevelEnumMap = {
  CefrLevel.a1: 'a1',
  CefrLevel.a2: 'a2',
  CefrLevel.b1: 'b1',
};
