import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/models/exam.dart';
import 'package:learn_app/services/exam_prompts.dart';

void main() {
  ExamQuestion mc(String id) => ExamQuestion(
        id: id,
        prompt: 'q $id',
        options: const ['a', 'b', 'c', 'd'],
        correctIndex: 1,
      );

  ExamQuestion free(String id) =>
      ExamQuestion(id: id, prompt: 'write $id', options: const [], correctIndex: -1);

  /// An exam with [n] questions in each of the five sections.
  Exam examOf(int n) => Exam(
        level: 'a1',
        parts: [
          for (final s in ExamSection.values)
            ExamPart(
              section: s,
              instructionsHu: 'csináld',
              passageTitle: '',
              passage: '',
              questions: [
                for (var i = 1; i <= n; i++)
                  s == ExamSection.writing
                      ? free('${s.name}$i')
                      : mc('${s.name}$i'),
              ],
            ),
        ],
      );

  /// Marks every question in [section] with [score], everything else 100.
  List<QuestionMark> marksWith(Exam exam, Map<ExamSection, int> scores) => [
        for (final part in exam.parts)
          for (final q in part.questions)
            QuestionMark(
              id: q.id,
              score: scores[part.section] ?? 100,
              explanationHu: '',
              expected: 'b',
            ),
      ];

  ExamResult resultOf(Exam exam, Map<ExamSection, int> scores) =>
      ExamResult.from(
        exam: exam,
        marks: marksWith(exam, scores),
        overallFeedbackHu: 'ok',
      );

  group('scoring', () {
    test('a perfect exam passes at 100%', () {
      final r = resultOf(examOf(4), {});
      expect(r.averagePercent, 100);
      expect(r.failedSections, isEmpty);
      expect(r.passed, isTrue);
    });

    test('section percent is the mean of its question scores', () {
      final exam = examOf(4);
      // 3 of 4 grammar questions right = 75%.
      final marks = [
        for (final part in exam.parts)
          for (var i = 0; i < part.questions.length; i++)
            QuestionMark(
              id: part.questions[i].id,
              score: part.section == ExamSection.grammar && i == 0 ? 0 : 100,
              explanationHu: '',
              expected: 'b',
            ),
      ];
      final r = ExamResult.from(exam: exam, marks: marks, overallFeedbackHu: '');
      final grammar =
          r.sections.firstWhere((s) => s.section == ExamSection.grammar);
      expect(grammar.percent, 75);
    });

    test('a section below 50% fails the exam even with a high average', () {
      // Four sections at 100, one at 40: average is 88 but the floor is broken.
      final r = resultOf(examOf(5), {ExamSection.listening: 40});
      expect(r.averagePercent, greaterThanOrEqualTo(ExamResult.passAveragePercent));
      expect(r.meetsAverage, isTrue);
      expect(r.failedSections.single.section, ExamSection.listening);
      expect(r.passed, isFalse);
    });

    test('clearing every floor is not enough without the average', () {
      // Everything at 60: no section fails, but the mean is under 70.
      final r = resultOf(examOf(5), {for (final s in ExamSection.values) s: 60});
      expect(r.failedSections, isEmpty);
      expect(r.averagePercent, 60);
      expect(r.meetsAverage, isFalse);
      expect(r.passed, isFalse);
    });

    test('exactly on both thresholds passes', () {
      final r = resultOf(examOf(5), {
        ExamSection.grammar: 50, // exactly the floor
        ExamSection.vocabulary: 90,
        ExamSection.reading: 60,
        ExamSection.listening: 70,
        ExamSection.writing: 80,
      });
      expect(r.averagePercent, ExamResult.passAveragePercent); // exactly 70
      expect(r.failedSections, isEmpty);
      expect(r.passed, isTrue);
    });

    test('an unmarked question counts as zero, it does not vanish', () {
      final exam = examOf(4);
      // The marker skipped one grammar question entirely.
      final all = marksWith(exam, {});
      final partial = all.where((m) => m.id != 'grammar1').toList();

      final r = ExamResult.from(
          exam: exam, marks: partial, overallFeedbackHu: '');
      final grammar =
          r.sections.firstWhere((s) => s.section == ExamSection.grammar);
      expect(grammar.percent, 75, reason: 'missing mark must score 0, not drop');
    });

    test('an empty exam cannot pass', () {
      final r = ExamResult.from(
        exam: const Exam(level: 'a1', parts: []),
        marks: const [],
        overallFeedbackHu: '',
      );
      expect(r.averagePercent, 0);
      expect(r.passed, isFalse);
    });

    test('scores are clamped to 0-100 when parsed', () {
      expect(QuestionMark.fromJson({'score': 250}).score, 100);
      expect(QuestionMark.fromJson({'score': -40}).score, 0);
      expect(QuestionMark.fromJson(const {}).score, 0);
    });
  });

  group('parsing', () {
    test('an empty options list marks a question as free text', () {
      expect(mc('g1').isFreeText, isFalse);
      expect(free('w1').isFreeText, isTrue);
      expect(
        ExamQuestion.fromJson(const {
          'id': 'w1',
          'prompt': 'Describe your day.',
          'options': <String>[],
          'correct_index': -1,
        }).isFreeText,
        isTrue,
      );
    });

    test('an unknown section name does not crash the parse', () {
      expect(
        ExamPart.fromJson(const {'section': 'nonsense'}).section,
        ExamSection.grammar,
      );
    });

    test('a full exam round-trips from the shape the schema describes', () {
      final exam = Exam.fromJson(const {
        'level': 'a2',
        'parts': [
          {
            'section': 'reading',
            'instructions_hu': 'Olvasd el.',
            'passage_title': 'A Day Out',
            'passage': 'Anna went to the park.',
            'questions': [
              {
                'id': 'r1',
                'prompt': 'Where did Anna go?',
                'options': ['home', 'the park', 'school', 'work'],
                'correct_index': 1,
              },
            ],
          },
        ],
      });
      expect(exam.level, 'a2');
      expect(exam.parts.single.section, ExamSection.reading);
      expect(exam.parts.single.passage, 'Anna went to the park.');
      expect(exam.allQuestions.single.options[1], 'the park');
    });
  });

  group('history', () {
    test('a stored attempt comes back with its paper and its marking', () {
      final exam = examOf(2);
      final attempt = ExamAttempt(
        takenAt: DateTime(2026, 7, 31, 9, 5),
        exam: exam,
        answers: {for (final q in exam.allQuestions) q.id: 'b'},
        marks: marksWith(exam, {ExamSection.writing: 40}),
        feedbackHu: 'Szép munka.',
      );

      final back = ExamAttempt.fromJson(attempt.toJson());

      expect(back, attempt, reason: 'value equality survives the round trip');
      expect(back.answers['grammar1'], 'b');
      expect(back.exam.allQuestions.length, exam.allQuestions.length);
      // The verdict is recomputed from the marks, not stored.
      expect(back.result.averagePercent, attempt.result.averagePercent);
      expect(back.result.failedSections.single.section, ExamSection.writing);
      expect(back.result.overallFeedbackHu, 'Szép munka.');
    });
  });

  group('prompts', () {
    for (final level in ['a1', 'a2', 'b1']) {
      test('$level generation prompt names every section and its size', () {
        final p = examGenerationPrompt(level);
        for (final entry in examSectionSizes.entries) {
          expect(p, contains(entry.key));
          expect(p, contains('${entry.value}'));
        }
        expect(p, contains(level.toUpperCase()));
        expect(p, contains('"level" to "$level"'));
      });

      test('$level prompts insist on English content, Hungarian help only', () {
        final p = examGenerationPrompt(level);
        expect(p, contains('ENGLISH'));
        expect(p, contains('instructions_hu'));
        // The one Hungarian-only field must be called out as the exception.
        expect(p, contains('ONLY field written in Hungarian'));
      });

      test('$level grading prompt demands a reason for every lost mark', () {
        final g = examGradingPrompt(level);
        expect(g, contains('HUNGARIAN'));
        expect(g, contains('explanation_hu'));
        expect(g, contains(level.toUpperCase()));
        // Leniency is the stated policy, not strictness.
        expect(markingTolerance(level), contains('Ignore capitalisation'));
      });

      test('$level syllabus reaches both prompts, so they cannot drift', () {
        final syllabus = levelSyllabus(level);
        expect(examGenerationPrompt(level), contains(syllabus));
        expect(examGradingPrompt(level), contains(syllabus));
      });
    }

    test('each level scopes different grammar', () {
      expect(levelSyllabus('a1'), contains('NOT IN SCOPE AT A1'));
      expect(levelSyllabus('a2'), contains('past simple'));
      expect(levelSyllabus('b1'), contains('present perfect'));
      expect(levelSyllabus('a1'), isNot(equals(levelSyllabus('b1'))));
    });
  });
}
