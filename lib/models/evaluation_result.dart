import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluation_result.freezed.dart';
part 'evaluation_result.g.dart';

@freezed
abstract class SentenceError with _$SentenceError {
  const factory SentenceError({
    @Default('') String original,
    @Default('') String corrected,
    @Default('') String explanationHu,
  }) = _SentenceError;

  factory SentenceError.fromJson(Map<String, dynamic> json) =>
      _$SentenceErrorFromJson(json);
}

@freezed
abstract class SentenceEvaluation with _$SentenceEvaluation {
  const factory SentenceEvaluation({
    @Default(0) int score, // 0-100
    @Default(false) bool isCorrect,
    @Default('') String corrected,
    @Default(<SentenceError>[]) List<SentenceError> errors,
    @Default('') String explanationHu,
  }) = _SentenceEvaluation;

  factory SentenceEvaluation.fromJson(Map<String, dynamic> json) =>
      _$SentenceEvaluationFromJson(json);

  /// JSON schema for OpenRouter structured output.
  static const schema = {
    'type': 'object',
    'additionalProperties': false,
    'required': ['score', 'is_correct', 'corrected', 'errors', 'explanation_hu'],
    'properties': {
      'score': {'type': 'integer'},
      'is_correct': {'type': 'boolean'},
      'corrected': {'type': 'string'},
      'errors': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': ['original', 'corrected', 'explanation_hu'],
          'properties': {
            'original': {'type': 'string'},
            'corrected': {'type': 'string'},
            'explanation_hu': {'type': 'string'},
          },
        },
      },
      'explanation_hu': {'type': 'string'},
    },
  };
}
