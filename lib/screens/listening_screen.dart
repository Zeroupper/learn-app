import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reading_exercise.dart';
import '../services/ai_service.dart';
import '../services/tts_service.dart';
import '../widgets/mc_question_card.dart';

const _topics = ['Utazás', 'Étel', 'Munka', 'Család', 'Hobbi', 'Természet', 'Sport'];
const _levels = ['a1', 'a2', 'b1'];

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  String _topic = _topics.first;
  String _level = 'a1';
  bool _loading = false;
  String? _error;
  ReadingExercise? _result;
  bool _revealed = false;
  Timer? _autoPlay;
  double _rate = 0.45; // Lassú 0.30 · Normál 0.45 · Gyors 0.60
  late final TtsService _tts;

  @override
  void initState() {
    super.initState();
    _tts = context.read<TtsService>(); // cache; unsafe to read in dispose()
  }

  @override
  void dispose() {
    _autoPlay?.cancel();
    _tts.stop();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
      _revealed = false;
    });
    _autoPlay?.cancel();
    try {
      final r = await context
          .read<AiService>()
          .generateReading(topic: _topic, level: _level);
      if (!mounted) return;
      setState(() => _result = r);
      // Start listening automatically after 3 seconds.
      _autoPlay = Timer(const Duration(seconds: 3), () {
        if (mounted) _tts.speak(r.text, rate: _rate);
      });
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.messageHu);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hallás utáni értés')),
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
                : const Icon(Icons.headphones),
            label: Text(_loading ? 'Generálás…' : 'Új feladat'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_result != null) _listening(_result!),
        ],
      ),
    );
  }

  Widget _listening(ReadingExercise r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              IconButton.filled(
                iconSize: 40,
                onPressed: () => _tts.speak(r.text, rate: _rate),
                icon: const Icon(Icons.volume_up),
              ),
              const SizedBox(height: 8),
              Text('Hallgasd meg, majd válaszolj a kérdésekre.',
                  style: Theme.of(context).textTheme.bodySmall),
              Text('(A lejátszás 3 másodperc múlva indul.)',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Text('Sebesség: ${_rate.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall),
              Row(
                children: [
                  const Icon(Icons.directions_walk, size: 18), // slow
                  Expanded(
                    child: Slider(
                      value: _rate,
                      min: 0.2,
                      max: 1.0,
                      divisions: 16, // 0.05 steps
                      label: _rate.toStringAsFixed(2),
                      onChanged: (v) => setState(() => _rate = v),
                      onChangeEnd: (v) =>
                          _tts.speak(r.text, rate: v), // preview at new speed
                    ),
                  ),
                  const Icon(Icons.directions_run, size: 18), // fast
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (r.questions.isNotEmpty) ...[
          Text('Kérdések', style: Theme.of(context).textTheme.titleLarge),
          for (final q in r.questions) McQuestionCard(q),
        ],
        const SizedBox(height: 12),
        if (!_revealed)
          OutlinedButton.icon(
            onPressed: () => setState(() => _revealed = true),
            icon: const Icon(Icons.visibility),
            label: const Text('Szöveg felfedése'),
          )
        else ...[
          Text(r.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(r.text, style: const TextStyle(fontSize: 17, height: 1.5)),
          if (r.glossary.isNotEmpty) ...[
            const Divider(height: 24),
            Text('Szószedet', style: Theme.of(context).textTheme.titleSmall),
            for (final g in r.glossary)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('${g.en} — ${g.hu}'),
              ),
          ],
        ],
      ],
    );
  }
}
