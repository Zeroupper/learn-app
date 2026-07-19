import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/evaluation_result.dart';
import '../services/ai_service.dart';
import '../services/tts_service.dart';
import '../widgets/feedback_style.dart';

const _topics = ['Utazás', 'Étel', 'Munka', 'Család', 'Hobbi', 'Időjárás', 'Város'];
const _levels = ['a1', 'a2', 'b1'];

class SentencePracticeScreen extends StatefulWidget {
  const SentencePracticeScreen({super.key});

  @override
  State<SentencePracticeScreen> createState() => _SentencePracticeScreenState();
}

class _SentencePracticeScreenState extends State<SentencePracticeScreen> {
  final _input = TextEditingController();
  String _topic = _topics.first;
  String _level = 'a1';
  bool _loading = false;
  bool _promptLoading = false;
  String? _prompt;
  String? _error;
  SentenceEvaluation? _result;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _pickTopic(String t) => setState(() {
        _topic = t;
        _prompt = null; // stale for the new topic
        _result = null;
      });

  void _pickLevel(String l) => setState(() {
        _level = l;
        _prompt = null;
        _result = null;
      });

  Future<void> _newPrompt() async {
    setState(() {
      _promptLoading = true;
      _error = null;
      _result = null;
    });
    try {
      final p = await context
          .read<AiService>()
          .generateWritingPrompt(topic: _topic, level: _level);
      if (mounted) setState(() => _prompt = p);
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.messageHu);
    } finally {
      if (mounted) setState(() => _promptLoading = false);
    }
  }

  Future<void> _evaluate() async {
    if (_input.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final r = await context.read<AiService>().evaluateSentence(
            topic: _topic,
            level: _level,
            sentence: _input.text.trim(),
            question: _prompt,
          );
      if (mounted) setState(() => _result = r);
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.messageHu);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mondatgyakorlás')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Téma'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              for (final t in _topics)
                ChoiceChip(
                  label: Text(t),
                  selected: _topic == t,
                  onSelected: (_) => _pickTopic(t),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Szint'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              for (final l in _levels)
                ChoiceChip(
                  label: Text(l.toUpperCase()),
                  selected: _level == l,
                  onSelected: (_) => _pickLevel(l),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _promptCard(context),
          const SizedBox(height: 12),
          TextField(
            controller: _input,
            maxLines: 5,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: _prompt == null ? 'Írj angolul' : 'A válaszod (angolul)',
              hintText: 'Write your answer in English…',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _loading ? null : _evaluate,
            icon: _loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            label: Text(_loading ? 'Értékelés…' : 'Értékelés kérése'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            _ErrorBox(_error!),
          ],
          if (_result != null) ...[
            const SizedBox(height: 16),
            _ResultView(_result!),
          ],
        ],
      ),
    );
  }

  Widget _promptCard(BuildContext context) {
    if (_prompt == null) {
      return OutlinedButton.icon(
        onPressed: _promptLoading ? null : _newPrompt,
        icon: _promptLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.quiz),
        label: Text(_promptLoading ? 'Feladat…' : 'Kérj egy feladatot'),
      );
    }
    final tts = context.read<TtsService>();
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.quiz, size: 18),
                const SizedBox(width: 6),
                Text('Feladat',
                    style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.volume_up, size: 20),
                  onPressed: () => tts.speak(_prompt!),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Új feladat',
                  icon: _promptLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.refresh, size: 20),
                  onPressed: _promptLoading ? null : _newPrompt,
                ),
              ],
            ),
            Text(_prompt!, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final SentenceEvaluation r;
  const _ResultView(this.r);

  Color _scoreColor() {
    if (r.score >= 80) return Colors.green;
    if (r.score >= 50) return Colors.amber.shade800;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final tts = context.read<TtsService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: _scoreColor(),
              radius: 24,
              child: Text('${r.score}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Text(r.isCorrect ? 'Helyes!' : 'Javításra szorul',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 16),
        Text('Javított mondat',
            style: Theme.of(context).textTheme.labelLarge),
        Row(
          children: [
            Expanded(
                child: Text(r.corrected,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => tts.speak(r.corrected),
            ),
          ],
        ),
        if (r.errors.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Hibák', style: Theme.of(context).textTheme.labelLarge),
          for (final e in r.errors)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(e.original,
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: feedbackColors(context, FeedbackKind.wrong)
                                    .fg)),
                      ),
                      const Icon(Icons.arrow_forward, size: 16),
                      Expanded(
                        child: Text('  ${e.corrected}',
                            style: TextStyle(
                                color: feedbackColors(
                                        context, FeedbackKind.correct)
                                    .fg,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                    if (e.explanationHu.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(e.explanationHu,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
        ],
        if (r.explanationHu.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(r.explanationHu),
        ],
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox(this.message);

  @override
  Widget build(BuildContext context) {
    final c = feedbackColors(context, FeedbackKind.wrong);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Icon(Icons.error_outline, color: c.fg),
        const SizedBox(width: 8),
        Expanded(child: Text(message, style: TextStyle(color: c.fg))),
      ]),
    );
  }
}
