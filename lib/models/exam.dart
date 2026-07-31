import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam.freezed.dart';
part 'exam.g.dart';

/// The five parts of a level exam. Order here is the order they are sat in.
enum ExamSection {
  grammar('Nyelvtan'),
  vocabulary('Szókincs'),
  reading('Olvasás'),
  listening('Hallás utáni értés'),
  writing('Írás');

  const ExamSection(this.labelHu);

  final String labelHu;
}

/// One exam question. [options] empty means a free-text answer, and then
/// [correctIndex] is -1 — the AI marks it rather than a lookup.
@freezed
abstract class ExamQuestion with _$ExamQuestion {
  const ExamQuestion._();

  const factory ExamQuestion({
    @Default('') String id,
    @Default('') String prompt,
    @Default(<String>[]) List<String> options,
    @Default(-1) int correctIndex,
  }) = _ExamQuestion;

  factory ExamQuestion.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionFromJson(json);

  bool get isFreeText => options.isEmpty;
}

/// One section of the exam, with the passage it is based on where relevant.
@freezed
abstract class ExamPart with _$ExamPart {
  const factory ExamPart({
    // An unknown section name must not sink the whole exam.
    @JsonKey(unknownEnumValue: ExamSection.grammar)
    @Default(ExamSection.grammar)
    ExamSection section,
    @Default('') String instructionsHu,

    /// Reading text, or the script read aloud for listening. Empty otherwise.
    @Default('') String passageTitle,
    @Default('') String passage,
    @Default(<ExamQuestion>[]) List<ExamQuestion> questions,
  }) = _ExamPart;

  factory ExamPart.fromJson(Map<String, dynamic> json) =>
      _$ExamPartFromJson(json);
}

@freezed
abstract class Exam with _$Exam {
  const Exam._();

  const factory Exam({
    @Default('a1') String level,
    @Default(<ExamPart>[]) List<ExamPart> parts,
  }) = _Exam;

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  List<ExamQuestion> get allQuestions => [
    for (final p in parts) ...p.questions,
  ];

  /// Strict JSON schema for structured output. Free-text questions use an
  /// empty `options` and `correct_index: -1` — strict mode has no nullables.
  static const schema = {
    'type': 'object',
    'additionalProperties': false,
    'required': ['level', 'parts'],
    'properties': {
      'level': {'type': 'string'},
      'parts': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': [
            'section',
            'instructions_hu',
            'passage_title',
            'passage',
            'questions',
          ],
          'properties': {
            'section': {
              'type': 'string',
              'enum': [
                'grammar',
                'vocabulary',
                'reading',
                'listening',
                'writing',
              ],
            },
            'instructions_hu': {'type': 'string'},
            'passage_title': {'type': 'string'},
            'passage': {'type': 'string'},
            'questions': {
              'type': 'array',
              'items': {
                'type': 'object',
                'additionalProperties': false,
                'required': ['id', 'prompt', 'options', 'correct_index'],
                'properties': {
                  'id': {'type': 'string'},
                  'prompt': {'type': 'string'},
                  'options': {
                    'type': 'array',
                    'items': {'type': 'string'},
                  },
                  'correct_index': {'type': 'integer'},
                },
              },
            },
          },
        },
      },
    },
  };
}

/// A score outside 0-100 would silently distort the section percentages, so it
/// is clamped on the way in rather than trusted.
int _clampScore(Object? raw) => ((raw as num?)?.toInt() ?? 0).clamp(0, 100);

/// The AI's verdict on one answer.
@freezed
abstract class QuestionMark with _$QuestionMark {
  const QuestionMark._();

  const factory QuestionMark({
    @Default('') String id,

    /// 0-100. Multiple choice lands on 0 or 100; writing is graded on the scale.
    @JsonKey(fromJson: _clampScore) @Default(0) int score,

    /// Why it is wrong, in Hungarian. Empty when fully correct.
    @Default('') String explanationHu,

    /// The model answer, so the student can compare.
    @Default('') String expected,
  }) = _QuestionMark;

  factory QuestionMark.fromJson(Map<String, dynamic> json) =>
      _$QuestionMarkFromJson(json);

  bool get isCorrect => score >= 100;

  static const schema = {
    'type': 'object',
    'additionalProperties': false,
    'required': ['marks', 'overall_feedback_hu'],
    'properties': {
      'marks': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': ['id', 'score', 'explanation_hu', 'expected'],
          'properties': {
            'id': {'type': 'string'},
            'score': {'type': 'integer'},
            'explanation_hu': {'type': 'string'},
            'expected': {'type': 'string'},
          },
        },
      },
      'overall_feedback_hu': {'type': 'string'},
    },
  };
}

/// Percentage for one section.
@freezed
abstract class SectionScore with _$SectionScore {
  const SectionScore._();

  const factory SectionScore({
    required ExamSection section,
    required int percent,
  }) = _SectionScore;

  bool get meetsMinimum => percent >= ExamResult.minimumPercent;
}

/// A marked exam: per-section percentages plus the pass/fail decision.
@freezed
abstract class ExamResult with _$ExamResult {
  const ExamResult._();

  const factory ExamResult({
    required String level,
    required List<SectionScore> sections,
    required List<QuestionMark> marks,
    required String overallFeedbackHu,
  }) = _ExamResult;

  /// No single section may fall below this.
  static const minimumPercent = 50;

  /// The average across sections must reach this.
  static const passAveragePercent = 70;

  /// Mean of the section percentages, rounded. Sections weigh equally, so a
  /// short writing part counts as much as a long grammar one.
  int get averagePercent {
    if (sections.isEmpty) return 0;
    final total = sections.fold<int>(0, (sum, s) => sum + s.percent);
    return (total / sections.length).round();
  }

  List<SectionScore> get failedSections =>
      sections.where((s) => !s.meetsMinimum).toList();

  bool get meetsAverage => averagePercent >= passAveragePercent;

  /// Both rules must hold: nothing below the floor, and a good enough mean.
  bool get passed =>
      sections.isNotEmpty && failedSections.isEmpty && meetsAverage;

  /// Builds the result by scoring [marks] against [exam]. The AI judges each
  /// answer; the arithmetic and the pass rules stay here where they can be
  /// tested and cannot drift.
  ///
  /// Scores are pooled per *section*, not per part: reading and listening are
  /// sat on two texts each, and the pass floor applies to the skill as a whole.
  static ExamResult from({
    required Exam exam,
    required List<QuestionMark> marks,
    required String overallFeedbackHu,
  }) {
    final byId = {for (final m in marks) m.id: m};
    final totals = <ExamSection, int>{};
    final counts = <ExamSection, int>{};

    for (final part in exam.parts) {
      for (final q in part.questions) {
        // A question the AI failed to mark counts as zero rather than
        // vanishing: silently dropping it would inflate the score.
        totals[part.section] =
            (totals[part.section] ?? 0) + (byId[q.id]?.score ?? 0);
        counts[part.section] = (counts[part.section] ?? 0) + 1;
      }
    }

    // Sit order, so the result reads in the order the exam was taken.
    final sections = [
      for (final section in ExamSection.values)
        if ((counts[section] ?? 0) > 0)
          SectionScore(
            section: section,
            percent: (totals[section]! / counts[section]!).round(),
          ),
    ];

    return ExamResult(
      level: exam.level,
      sections: sections,
      marks: marks,
      overallFeedbackHu: overallFeedbackHu,
    );
  }
}

/// A sat and marked exam, kept so the corrected paper can be reopened later.
///
/// Only the raw inputs are stored — the section percentages and the pass
/// decision are recomputed by [ExamResult.from], so a change to the marking
/// rules applies to old papers too.
@freezed
abstract class ExamAttempt with _$ExamAttempt {
  const ExamAttempt._();

  const factory ExamAttempt({
    required DateTime takenAt,
    required Exam exam,

    /// Question id -> the answer the student gave.
    @Default(<String, String>{}) Map<String, String> answers,
    @Default(<QuestionMark>[]) List<QuestionMark> marks,
    @Default('') String feedbackHu,
  }) = _ExamAttempt;

  factory ExamAttempt.fromJson(Map<String, dynamic> json) =>
      _$ExamAttemptFromJson(json);

  ExamResult get result => ExamResult.from(
    exam: exam,
    marks: marks,
    overallFeedbackHu: feedbackHu,
  );
}
