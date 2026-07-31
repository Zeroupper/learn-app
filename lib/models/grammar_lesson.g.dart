// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrammarExample _$GrammarExampleFromJson(Map<String, dynamic> json) =>
    _GrammarExample(en: json['en'] as String, hu: json['hu'] as String);

Map<String, dynamic> _$GrammarExampleToJson(_GrammarExample instance) =>
    <String, dynamic>{'en': instance.en, 'hu': instance.hu};

_GrammarSection _$GrammarSectionFromJson(Map<String, dynamic> json) =>
    _GrammarSection(
      headingHu: json['heading_hu'] as String,
      bodyHu: json['body_hu'] as String,
      examples:
          (json['examples'] as List<dynamic>?)
              ?.map((e) => GrammarExample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GrammarExample>[],
    );

Map<String, dynamic> _$GrammarSectionToJson(_GrammarSection instance) =>
    <String, dynamic>{
      'heading_hu': instance.headingHu,
      'body_hu': instance.bodyHu,
      'examples': instance.examples.map((e) => e.toJson()).toList(),
    };

_GrammarExercise _$GrammarExerciseFromJson(Map<String, dynamic> json) =>
    _GrammarExercise(
      promptHu: json['prompt_hu'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctIndex: (json['correct_index'] as num).toInt(),
      explanationHu: json['explanation_hu'] as String,
    );

Map<String, dynamic> _$GrammarExerciseToJson(_GrammarExercise instance) =>
    <String, dynamic>{
      'prompt_hu': instance.promptHu,
      'options': instance.options,
      'correct_index': instance.correctIndex,
      'explanation_hu': instance.explanationHu,
    };

_GrammarLessonMeta _$GrammarLessonMetaFromJson(Map<String, dynamic> json) =>
    _GrammarLessonMeta(
      id: json['id'] as String,
      file: json['file'] as String,
      titleHu: json['title_hu'] as String,
      subtitleHu: json['subtitle_hu'] as String,
      level: $enumDecode(_$CefrLevelEnumMap, json['level']),
    );

Map<String, dynamic> _$GrammarLessonMetaToJson(_GrammarLessonMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'title_hu': instance.titleHu,
      'subtitle_hu': instance.subtitleHu,
      'level': _$CefrLevelEnumMap[instance.level]!,
    };

const _$CefrLevelEnumMap = {
  CefrLevel.a1: 'a1',
  CefrLevel.a2: 'a2',
  CefrLevel.b1: 'b1',
};

_GrammarLesson _$GrammarLessonFromJson(Map<String, dynamic> json) =>
    _GrammarLesson(
      id: json['id'] as String,
      titleHu: json['title_hu'] as String,
      subtitleHu: json['subtitle_hu'] as String,
      level: $enumDecode(_$CefrLevelEnumMap, json['level']),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => GrammarSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => GrammarExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GrammarLessonToJson(_GrammarLesson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title_hu': instance.titleHu,
      'subtitle_hu': instance.subtitleHu,
      'level': _$CefrLevelEnumMap[instance.level]!,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
    };
