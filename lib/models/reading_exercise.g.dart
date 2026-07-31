// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingQuestion _$ReadingQuestionFromJson(Map<String, dynamic> json) =>
    _ReadingQuestion(
      question: json['question'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      correctIndex: (json['correct_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReadingQuestionToJson(_ReadingQuestion instance) =>
    <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'correct_index': instance.correctIndex,
    };

_GlossaryEntry _$GlossaryEntryFromJson(Map<String, dynamic> json) =>
    _GlossaryEntry(
      en: json['en'] as String? ?? '',
      hu: json['hu'] as String? ?? '',
    );

Map<String, dynamic> _$GlossaryEntryToJson(_GlossaryEntry instance) =>
    <String, dynamic>{'en': instance.en, 'hu': instance.hu};

_ReadingExercise _$ReadingExerciseFromJson(Map<String, dynamic> json) =>
    _ReadingExercise(
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => ReadingQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReadingQuestion>[],
      glossary:
          (json['glossary'] as List<dynamic>?)
              ?.map((e) => GlossaryEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GlossaryEntry>[],
    );

Map<String, dynamic> _$ReadingExerciseToJson(_ReadingExercise instance) =>
    <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'glossary': instance.glossary.map((e) => e.toJson()).toList(),
    };
