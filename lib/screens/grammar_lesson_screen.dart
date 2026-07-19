import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/grammar_repository.dart';
import '../data/settings_repository.dart';
import '../models/grammar_lesson.dart';
import '../services/tts_service.dart';
import '../widgets/feedback_style.dart';

class GrammarLessonScreen extends StatefulWidget {
  final GrammarLessonMeta meta;
  const GrammarLessonScreen({super.key, required this.meta});

  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen> {
  late Future<GrammarLesson> _lesson;
  final Map<int, int> _answers = {}; // exercise index -> chosen option
  bool _markedDone = false;

  @override
  void initState() {
    super.initState();
    _lesson = context.read<GrammarRepository>().loadLesson(widget.meta.file);
  }

  void _answer(GrammarLesson lesson, int exercise, int option) {
    setState(() => _answers[exercise] = option);
    if (_answers.length == lesson.exercises.length && !_markedDone) {
      _markedDone = true;
      context.read<SettingsRepository>().setGrammarDone(lesson.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.meta.titleHu)),
      body: FutureBuilder<GrammarLesson>(
        future: _lesson,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lesson = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final section in lesson.sections) _section(context, section),
              const Divider(height: 32),
              Text('Gyakorlás',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              for (var i = 0; i < lesson.exercises.length; i++)
                _exercise(context, lesson, i, lesson.exercises[i]),
              if (_answers.length == lesson.exercises.length)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Lecke kész!',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _section(BuildContext context, GrammarSection s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(s.headingHu,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(s.bodyHu),
        const SizedBox(height: 8),
        for (final ex in s.examples) _exampleRow(context, ex),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _exampleRow(BuildContext context, GrammarExample ex) {
    final tts = context.read<TtsService>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.volume_up, size: 18),
            onPressed: () => tts.speak(ex.en),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                      text: ex.en,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: '  —  ${ex.hu}',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exercise(
      BuildContext context, GrammarLesson lesson, int index, GrammarExercise ex) {
    final chosen = _answers[index];
    final answered = chosen != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ex.promptHu,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (var o = 0; o < ex.options.length; o++)
              _option(lesson, index, ex, o, chosen),
            if (answered) ...[
              const SizedBox(height: 8),
              Text(
                chosen == ex.correctIndex
                    ? '✓ ${ex.explanationHu}'
                    : '✗ ${ex.explanationHu}',
                style: TextStyle(
                    color: feedbackColors(
                            context,
                            chosen == ex.correctIndex
                                ? FeedbackKind.correct
                                : FeedbackKind.wrong)
                        .fg),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _option(GrammarLesson lesson, int index, GrammarExercise ex, int option,
      int? chosen) {
    final answered = chosen != null;
    Color? bg;
    if (answered) {
      if (option == ex.correctIndex) {
        bg = feedbackColors(context, FeedbackKind.correct).bg;
      } else if (option == chosen) {
        bg = feedbackColors(context, FeedbackKind.wrong).bg;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: answered ? null : () => _answer(lesson, index, option),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(ex.options[option]),
        ),
      ),
    );
  }
}
