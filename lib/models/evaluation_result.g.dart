// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SentenceError _$SentenceErrorFromJson(Map<String, dynamic> json) =>
    _SentenceError(
      original: json['original'] as String? ?? '',
      corrected: json['corrected'] as String? ?? '',
      explanationHu: json['explanation_hu'] as String? ?? '',
    );

Map<String, dynamic> _$SentenceErrorToJson(_SentenceError instance) =>
    <String, dynamic>{
      'original': instance.original,
      'corrected': instance.corrected,
      'explanation_hu': instance.explanationHu,
    };

_SentenceEvaluation _$SentenceEvaluationFromJson(Map<String, dynamic> json) =>
    _SentenceEvaluation(
      score: (json['score'] as num?)?.toInt() ?? 0,
      isCorrect: json['is_correct'] as bool? ?? false,
      corrected: json['corrected'] as String? ?? '',
      errors:
          (json['errors'] as List<dynamic>?)
              ?.map((e) => SentenceError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SentenceError>[],
      explanationHu: json['explanation_hu'] as String? ?? '',
    );

Map<String, dynamic> _$SentenceEvaluationToJson(_SentenceEvaluation instance) =>
    <String, dynamic>{
      'score': instance.score,
      'is_correct': instance.isCorrect,
      'corrected': instance.corrected,
      'errors': instance.errors.map((e) => e.toJson()).toList(),
      'explanation_hu': instance.explanationHu,
    };
