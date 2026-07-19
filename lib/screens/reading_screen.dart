import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/vocab_repository.dart';
import '../models/reading_exercise.dart';
import '../services/ai_service.dart';
import '../services/tts_service.dart';
import '../widgets/mc_question_card.dart';

const _topics = ['Utazás', 'Étel', 'Munka', 'Család', 'Hobbi', 'Természet', 'Sport'];
const _levels = ['a1', 'a2', 'b1'];

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  String _topic = _topics.first;
  String _level = 'a1';
  bool _loading = false;
  String? _error;
  ReadingExercise? _result;

  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final r = await context
          .read<AiService>()
          .generateReading(topic: _topic, level: _level);
      if (mounted) setState(() => _result = r);
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.messageHu);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _lookup(String rawWord) {
    final word = rawWord.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ]'), '').toLowerCase();
    if (word.isEmpty) return;
    String? hu;
    for (final g in _result!.glossary) {
      if (g.en.toLowerCase() == word) {
        hu = g.hu;
        break;
      }
    }
    hu ??= context.read<VocabRepository>().byEn(word)?.hu.join(', ');
    final tts = context.read<TtsService>();
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(word,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => tts.speak(word),
              ),
            ]),
            const SizedBox(height: 8),
            Text(hu ?? 'Nincs találat',
                style: TextStyle(
                    fontSize: 16,
                    color: hu == null ? Colors.grey : null)),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpans(String text) {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
    final spans = <InlineSpan>[];
    for (final token in text.split(RegExp(r'(\s+)'))) {
      if (token.trim().isEmpty) {
        spans.add(TextSpan(text: token));
        continue;
      }
      final rec = TapGestureRecognizer()..onTap = () => _lookup(token);
      _recognizers.add(rec);
      spans.add(TextSpan(
        text: '$token ',
        recognizer: rec,
      ));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Olvasás')),
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
                  onSelected: (_) => setState(() => _topic = t),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Szint'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              for (final l in _levels)
                ChoiceChip(
                  label: Text(l.toUpperCase()),
                  selected: _level == l,
                  onSelected: (_) => setState(() => _level = l),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _loading ? null : _generate,
            icon: _loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.auto_stories),
            label: Text(_loading ? 'Generálás…' : 'Szöveg kérése'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_result != null) _reading(_result!),
        ],
      ),
    );
  }

  Widget _reading(ReadingExercise r) {
    final tts = context.read<TtsService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: Text(r.title,
                    style: Theme.of(context).textTheme.titleLarge)),
            IconButton(
              icon: const Icon(Icons.volume_up),
              tooltip: 'Szöveg felolvasása',
              onPressed: () => tts.speak(r.text),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Koppints egy szóra a fordításért.',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(style: const TextStyle(fontSize: 17, height: 1.5),
              children: _buildSpans(r.text)),
        ),
        if (r.questions.isNotEmpty) ...[
          const Divider(height: 32),
          Text('Kérdések', style: Theme.of(context).textTheme.titleLarge),
          for (final q in r.questions) McQuestionCard(q),
        ],
      ],
    );
  }
}
