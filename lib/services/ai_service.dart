import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/evaluation_result.dart';
import '../models/exam.dart';
import '../models/reading_exercise.dart';
import 'exam_prompts.dart';

/// A user-facing error with a Hungarian message.
class AiException implements Exception {
  final String messageHu;
  AiException(this.messageHu);
  @override
  String toString() => messageHu;
}

/// OpenRouter (OpenAI-compatible) chat client. The [http.Client] and the
/// key/model providers are injected so the whole class is unit-testable
/// without a network or secure storage.
class AiService {
  static const _url = 'https://openrouter.ai/api/v1/chat/completions';
  static const _timeout = Duration(seconds: 25);

  final http.Client client;
  final Future<String?> Function() getApiKey;
  final Future<String> Function() getModel;

  AiService({
    required this.client,
    required this.getApiKey,
    required this.getModel,
  });

  /// Generates one short English writing prompt/question for the topic+level.
  Future<String> generateWritingPrompt({
    required String topic,
    required String level,
  }) async {
    final json = await _chat(
      system:
          'You are an English teacher for Hungarian learners. Write ONE short, '
          'clear writing prompt in ENGLISH at CEFR ${level.toUpperCase()} level '
          'about the given topic (topic is in Hungarian). The student will '
          'answer it in English with a few sentences or a short paragraph. '
          'Return JSON only: {"prompt": "..."}.',
      user: 'Topic (in Hungarian): $topic\nLevel: $level',
      schema: const {
        'type': 'object',
        'additionalProperties': false,
        'required': ['prompt'],
        'properties': {'prompt': {'type': 'string'}},
      },
      schemaName: 'writing_prompt',
      maxTokens: 512,
    );
    return json['prompt'] as String? ?? '';
  }

  /// Evaluates the student's English writing. When [question] is given, scoring
  /// also considers how well the answer addresses that question.
  Future<SentenceEvaluation> evaluateSentence({
    required String topic,
    required String level,
    required String sentence,
    String? question,
  }) async {
    final task = (question == null || question.isEmpty)
        ? 'on the topic "$topic"'
        : 'answering this question: "$question"';
    final json = await _chat(
      system:
          'You are an English teacher for Hungarian speakers. Evaluate the '
          "student's English writing at CEFR ${level.toUpperCase()} level, "
          '$task. Score from 0 to 100 based on grammar, vocabulary'
          '${question == null || question.isEmpty ? '' : ', and how well it '
              'answers the question'}.\n\n'
          '${_rubric(level)}\n\n'
          'Grade against the expectations for THIS level only: do not penalise a '
          'student for not using grammar above their level, but do flag errors in '
          'structures they should know at this level. List each concrete error '
          'with its correction. Write ALL explanations in Hungarian, simply and '
          'encouragingly. Return JSON only.',
      user: [
        'Topic: $topic',
        'Level: $level',
        if (question != null && question.isNotEmpty) 'Question: $question',
        'Student answer: "$sentence"',
      ].join('\n'),
      schema: SentenceEvaluation.schema,
      schemaName: 'evaluation',
      maxTokens: 2048,
    );
    return SentenceEvaluation.fromJson(json);
  }

  Future<ReadingExercise> generateReading({
    required String topic,
    required String level,
  }) async {
    final words = switch (level.toLowerCase()) {
      'a1' => '60-90',
      'a2' => '100-140',
      _ => '150-200',
    };
    final json = await _chat(
      system:
          'You are an English teacher creating English reading practice for '
          'Hungarian learners. The topic is given in Hungarian, but you MUST '
          'write everything in ENGLISH except where noted.\n'
          '- "title": a short ENGLISH title.\n'
          '- "text": the reading passage, written entirely in ENGLISH, at CEFR '
          '${level.toUpperCase()} level, $words words long. NEVER write the text '
          'in Hungarian.\n'
          '- "questions": exactly 3 comprehension questions in ENGLISH, each with '
          '3 ENGLISH options.\n'
          '- "glossary": the 8-12 hardest ENGLISH words from the text; "en" is the '
          'English word, "hu" is its Hungarian translation.\n'
          'Return JSON only.',
      user: 'Topic (in Hungarian): $topic\nLevel: $level',
      schema: ReadingExercise.schema,
      schemaName: 'reading',
      maxTokens: 4096,
    );
    return ReadingExercise.fromJson(json);
  }

  /// Builds a whole level exam — all five sections — in one call.
  Future<Exam> generateExam({required String level}) async {
    final json = await _chat(
      system: examGenerationPrompt(level),
      user: 'Write the complete ${level.toUpperCase()} exam now.',
      schema: Exam.schema,
      schemaName: 'exam',
      // ~60 questions, two passages and two scripts in one response — far more
      // output than any single exercise, and a truncated exam is a dead exam.
      maxTokens: 16384,
      timeout: const Duration(seconds: 180),
    );
    return Exam.fromJson(json);
  }

  /// Marks a completed exam. [answers] maps question id to the student's
  /// response: the chosen option's text, or their writing. A missing or empty
  /// entry is presented as unanswered rather than omitted, so the marker
  /// returns a zero for it instead of skipping the question.
  Future<({List<QuestionMark> marks, String feedbackHu})> gradeExam({
    required Exam exam,
    required Map<String, String> answers,
  }) async {
    final sb = StringBuffer();
    for (final part in exam.parts) {
      if (part.questions.isEmpty) continue;
      sb.writeln('## SECTION: ${part.section.name}');
      if (part.passage.isNotEmpty) {
        sb.writeln('Passage the student worked from:');
        sb.writeln(part.passage);
      }
      for (final q in part.questions) {
        final given = answers[q.id]?.trim() ?? '';
        sb.writeln('---');
        sb.writeln('id: ${q.id}');
        sb.writeln('question: ${q.prompt}');
        if (!q.isFreeText) {
          sb.writeln('options: ${q.options.join(' | ')}');
          final i = q.correctIndex;
          final correct =
              (i >= 0 && i < q.options.length) ? q.options[i] : '(unknown)';
          sb.writeln('correct answer: $correct');
        }
        sb.writeln('student answer: ${given.isEmpty ? '(no answer)' : given}');
      }
      sb.writeln();
    }

    final json = await _chat(
      system: examGradingPrompt(exam.level),
      user: sb.toString(),
      schema: QuestionMark.schema,
      schemaName: 'exam_marks',
      // One Hungarian explanation per question, for every question sat.
      maxTokens: 16384,
      timeout: const Duration(seconds: 180),
    );

    return (
      marks: (json['marks'] as List? ?? [])
          .map((e) => QuestionMark.fromJson(e as Map<String, dynamic>))
          .toList(),
      feedbackHu: json['overall_feedback_hu'] as String? ?? '',
    );
  }

  /// Level-specific marking framework so corrections match the CEFR level.
  static String _rubric(String level) => switch (level.toLowerCase()) {
        'a1' =>
          'A1 expectations: simple present tense, "to be", basic SVO word '
              'order, articles (a/an/the), common everyday vocabulary, singular/'
              'plural. Focus feedback on these basics. Be lenient and '
              'encouraging: short, simple, correct sentences should score high '
              '(80-100). Do not expect connectors or complex clauses.',
        'a2' =>
          'A2 expectations: past simple and future (will/going to), present '
              'continuous, basic connectors (and, but, because, so), prepositions '
              'of time/place, comparatives, countable/uncountable. Check tense '
              'consistency, subject-verb agreement, and prepositions. Expect 2-4 '
              'connected sentences.',
        _ =>
          'B1 expectations: a range of tenses incl. present perfect, first '
              'conditional, modals, relative clauses, richer connectors and '
              'vocabulary, expressing opinions with reasons. Check tense/aspect '
              'choice, articles, word choice and collocation, and coherence. '
              'Expect a short connected paragraph; mark more strictly.',
      };

  Future<Map<String, dynamic>> _chat({
    required String system,
    required String user,
    required Map<String, dynamic> schema,
    required String schemaName,
    required int maxTokens,
    Duration? timeout,
  }) async {
    final key = await getApiKey();
    if (key == null || key.isEmpty) {
      throw AiException('Adj meg egy OpenRouter API kulcsot a Beállításokban.');
    }
    final model = await getModel();
    final body = jsonEncode({
      'model': model,
      'max_tokens': maxTokens,
      'messages': [
        {'role': 'system', 'content': system},
        {'role': 'user', 'content': user},
      ],
      'response_format': {
        'type': 'json_schema',
        'json_schema': {'name': schemaName, 'strict': true, 'schema': schema},
      },
    });

    var attempt = 0;
    while (true) {
      attempt++;
      http.Response resp;
      try {
        resp = await client
            .post(Uri.parse(_url),
                headers: {
                  'Authorization': 'Bearer $key',
                  'content-type': 'application/json',
                },
                body: body)
            .timeout(timeout ?? _timeout);
      } on TimeoutException {
        throw AiException('Időtúllépés. Ellenőrizd az internetet és próbáld újra.');
      } on AiException {
        rethrow;
      } catch (_) {
        throw AiException('Hálózati hiba. Ellenőrizd az internetkapcsolatot.');
      }

      final code = resp.statusCode;
      if (code == 200) return _parse(resp.body);
      if (code == 401) {
        throw AiException('Érvénytelen API kulcs. Ellenőrizd a Beállításokban.');
      }
      if (code == 402) {
        throw AiException('Nincs elég OpenRouter kredit a fiókodban.');
      }
      if (code == 429 && attempt <= 2) {
        final wait = int.tryParse(resp.headers['retry-after'] ?? '') ?? 2;
        await Future<void>.delayed(Duration(seconds: wait.clamp(1, 10)));
        continue;
      }
      if (code >= 500 && attempt <= 3) {
        await Future<void>.delayed(Duration(seconds: 1 << (attempt - 1)));
        continue;
      }
      throw AiException('Szerverhiba ($code). Próbáld újra később.');
    }
  }

  Map<String, dynamic> _parse(String responseBody) {
    Map<String, dynamic> root;
    try {
      root = jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (_) {
      throw AiException('Nem sikerült feldolgozni a választ, próbáld újra.');
    }
    final choices = root['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw AiException('Üres válasz érkezett, próbáld újra.');
    }
    final choice = choices.first as Map<String, dynamic>;
    if (choice['finish_reason'] == 'length') {
      throw AiException('A válasz túl hosszú lett. Próbáld újra.');
    }
    final content = (choice['message'] as Map<String, dynamic>?)?['content'];
    if (content is! String || content.trim().isEmpty) {
      throw AiException('A modell nem adott választ, próbáld újra.');
    }
    try {
      return jsonDecode(_stripFences(content)) as Map<String, dynamic>;
    } catch (_) {
      throw AiException('Nem sikerült feldolgozni a választ, próbáld újra.');
    }
  }

  /// Strip a ```json … ``` (or plain ``` … ```) fence some models add.
  static String _stripFences(String s) {
    var t = s.trim();
    if (t.startsWith('```')) {
      t = t.replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '');
      if (t.endsWith('```')) t = t.substring(0, t.length - 3);
    }
    return t.trim();
  }
}
