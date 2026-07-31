import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_exercise.freezed.dart';
part 'reading_exercise.g.dart';

@freezed
abstract class ReadingQuestion with _$ReadingQuestion {
  const factory ReadingQuestion({
    @Default('') String question,
    @Default(<String>[]) List<String> options,
    @Default(0) int correctIndex,
  }) = _ReadingQuestion;

  factory ReadingQuestion.fromJson(Map<String, dynamic> json) =>
      _$ReadingQuestionFromJson(json);
}

@freezed
abstract class GlossaryEntry with _$GlossaryEntry {
  const factory GlossaryEntry({
    @Default('') String en,
    @Default('') String hu,
  }) = _GlossaryEntry;

  factory GlossaryEntry.fromJson(Map<String, dynamic> json) =>
      _$GlossaryEntryFromJson(json);
}

@freezed
abstract class ReadingExercise with _$ReadingExercise {
  const factory ReadingExercise({
    @Default('') String title,
    @Default('') String text,
    @Default(<ReadingQuestion>[]) List<ReadingQuestion> questions,
    @Default(<GlossaryEntry>[]) List<GlossaryEntry> glossary,
  }) = _ReadingExercise;

  factory ReadingExercise.fromJson(Map<String, dynamic> json) =>
      _$ReadingExerciseFromJson(json);

  static const schema = {
    'type': 'object',
    'additionalProperties': false,
    'required': ['title', 'text', 'questions', 'glossary'],
    'properties': {
      'title': {'type': 'string'},
      'text': {'type': 'string'},
      'questions': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': ['question', 'options', 'correct_index'],
          'properties': {
            'question': {'type': 'string'},
            'options': {
              'type': 'array',
              'items': {'type': 'string'},
            },
            'correct_index': {'type': 'integer'},
          },
        },
      },
      'glossary': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': ['en', 'hu'],
          'properties': {
            'en': {'type': 'string'},
            'hu': {'type': 'string'},
          },
        },
      },
    },
  };
}
