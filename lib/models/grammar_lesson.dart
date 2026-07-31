import 'package:freezed_annotation/freezed_annotation.dart';

import 'vocab_word.dart';

part 'grammar_lesson.freezed.dart';
part 'grammar_lesson.g.dart';

@freezed
abstract class GrammarExample with _$GrammarExample {
  const factory GrammarExample({required String en, required String hu}) =
      _GrammarExample;

  factory GrammarExample.fromJson(Map<String, dynamic> json) =>
      _$GrammarExampleFromJson(json);
}

@freezed
abstract class GrammarSection with _$GrammarSection {
  const factory GrammarSection({
    required String headingHu,
    required String bodyHu,
    @Default(<GrammarExample>[]) List<GrammarExample> examples,
  }) = _GrammarSection;

  factory GrammarSection.fromJson(Map<String, dynamic> json) =>
      _$GrammarSectionFromJson(json);
}

@freezed
abstract class GrammarExercise with _$GrammarExercise {
  const factory GrammarExercise({
    required String promptHu,
    required List<String> options,
    required int correctIndex,
    required String explanationHu,
  }) = _GrammarExercise;

  factory GrammarExercise.fromJson(Map<String, dynamic> json) =>
      _$GrammarExerciseFromJson(json);
}

/// Lightweight metadata from index.json (list screen, no full load).
@freezed
abstract class GrammarLessonMeta with _$GrammarLessonMeta {
  const factory GrammarLessonMeta({
    required String id,
    required String file,
    required String titleHu,
    required String subtitleHu,
    required CefrLevel level,
  }) = _GrammarLessonMeta;

  factory GrammarLessonMeta.fromJson(Map<String, dynamic> json) =>
      _$GrammarLessonMetaFromJson(json);
}

@freezed
abstract class GrammarLesson with _$GrammarLesson {
  const factory GrammarLesson({
    required String id,
    required String titleHu,
    required String subtitleHu,
    required CefrLevel level,
    required List<GrammarSection> sections,
    required List<GrammarExercise> exercises,
  }) = _GrammarLesson;

  factory GrammarLesson.fromJson(Map<String, dynamic> json) =>
      _$GrammarLessonFromJson(json);
}
