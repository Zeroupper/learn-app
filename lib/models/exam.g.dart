// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamQuestion _$ExamQuestionFromJson(Map<String, dynamic> json) =>
    _ExamQuestion(
      id: json['id'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      correctIndex: (json['correct_index'] as num?)?.toInt() ?? -1,
    );

Map<String, dynamic> _$ExamQuestionToJson(_ExamQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prompt': instance.prompt,
      'options': instance.options,
      'correct_index': instance.correctIndex,
    };

_ExamPart _$ExamPartFromJson(Map<String, dynamic> json) => _ExamPart(
  section:
      $enumDecodeNullable(
        _$ExamSectionEnumMap,
        json['section'],
        unknownValue: ExamSection.grammar,
      ) ??
      ExamSection.grammar,
  instructionsHu: json['instructions_hu'] as String? ?? '',
  passageTitle: json['passage_title'] as String? ?? '',
  passage: json['passage'] as String? ?? '',
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => ExamQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ExamQuestion>[],
);

Map<String, dynamic> _$ExamPartToJson(_ExamPart instance) => <String, dynamic>{
  'section': _$ExamSectionEnumMap[instance.section]!,
  'instructions_hu': instance.instructionsHu,
  'passage_title': instance.passageTitle,
  'passage': instance.passage,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

const _$ExamSectionEnumMap = {
  ExamSection.grammar: 'grammar',
  ExamSection.vocabulary: 'vocabulary',
  ExamSection.reading: 'reading',
  ExamSection.listening: 'listening',
  ExamSection.writing: 'writing',
};

_Exam _$ExamFromJson(Map<String, dynamic> json) => _Exam(
  level: json['level'] as String? ?? 'a1',
  parts:
      (json['parts'] as List<dynamic>?)
          ?.map((e) => ExamPart.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ExamPart>[],
);

Map<String, dynamic> _$ExamToJson(_Exam instance) => <String, dynamic>{
  'level': instance.level,
  'parts': instance.parts.map((e) => e.toJson()).toList(),
};

_QuestionMark _$QuestionMarkFromJson(Map<String, dynamic> json) =>
    _QuestionMark(
      id: json['id'] as String? ?? '',
      score: json['score'] == null ? 0 : _clampScore(json['score']),
      explanationHu: json['explanation_hu'] as String? ?? '',
      expected: json['expected'] as String? ?? '',
    );

Map<String, dynamic> _$QuestionMarkToJson(_QuestionMark instance) =>
    <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'explanation_hu': instance.explanationHu,
      'expected': instance.expected,
    };

_ExamAttempt _$ExamAttemptFromJson(Map<String, dynamic> json) => _ExamAttempt(
  takenAt: DateTime.parse(json['taken_at'] as String),
  exam: Exam.fromJson(json['exam'] as Map<String, dynamic>),
  answers:
      (json['answers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  marks:
      (json['marks'] as List<dynamic>?)
          ?.map((e) => QuestionMark.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuestionMark>[],
  feedbackHu: json['feedback_hu'] as String? ?? '',
);

Map<String, dynamic> _$ExamAttemptToJson(_ExamAttempt instance) =>
    <String, dynamic>{
      'taken_at': instance.takenAt.toIso8601String(),
      'exam': instance.exam.toJson(),
      'answers': instance.answers,
      'marks': instance.marks.map((e) => e.toJson()).toList(),
      'feedback_hu': instance.feedbackHu,
    };
