import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/study_controller.dart';
import '../models/review_state.dart';
import '../services/tts_service.dart';
import '../widgets/answer_feedback_banner.dart';

class StudyScreen extends StatefulWidget {
  final StudyController controller;
  const StudyScreen({super.key, required this.controller});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final _input = TextEditingController();
  final _focus = FocusNode();

  StudyController get c => widget.controller;
  TtsService get _tts => context.read<TtsService>();

  @override
  void initState() {
    super.initState();
    c.addListener(_onChange);
  }

  @override
  void dispose() {
    c.removeListener(_onChange);
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChange() => setState(() {});

  Future<void> _submit() async {
    if (_input.text.trim().isEmpty || c.phase != StudyPhase.prompting) return;
    _focus.unfocus(); // hide the keyboard to reveal the result banner
    await c.check(_input.text);
    if (c.phase == StudyPhase.correct || c.phase == StudyPhase.almost) {
      _tts.praise();
    }
  }

  Future<void> _proceed() async {
    _input.clear();
    await c.proceed();
    if (!c.isFinished) {
      _focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: c.isFinished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: LinearProgressIndicator(value: c.progress),
          titleSpacing: 16,
        ),
        body: c.isFinished ? _summary() : _card(),
      ),
    );
  }

  Widget _card() {
    final p = c.prompt!;
    final checked = c.phase != StudyPhase.prompting;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Chip(
                    label: Text(p.direction == Direction.enToHu
                        ? 'Angol → Magyar'
                        : 'Magyar → Angol'),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        p.promptText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // TTS only speaks English; hide on the Hungarian prompt side.
                    if (p.direction == Direction.enToHu)
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => _tts.speak(p.englishText),
                      ),
                  ],
                ),
                if (p.word.pos.isNotEmpty)
                  Center(
                    child: Text(p.word.pos,
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                const SizedBox(height: 32),
                TextField(
                  controller: _input,
                  focusNode: _focus,
                  autofocus: true,
                  enabled: !checked,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: p.direction == Direction.enToHu
                        ? 'Írd be magyarul'
                        : 'Type in English',
                  ),
                ),
              ],
            ),
          ),
        ),
        if (checked)
          AnswerFeedbackBanner(
            phase: c.phase,
            prompt: p,
            userAnswer: c.lastInput,
            onSpeak: _tts.speak,
            onProceed: _proceed,
          )
        else
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Ellenőrzés'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _summary() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
          const SizedBox(height: 16),
          Text('Kész!', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Helyes: ${c.correctCount}   Hibás: ${c.wrongCount}'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vissza'),
          ),
        ],
      ),
    );
  }

  void _confirmQuit() async {
    final quit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kilépsz?'),
        content: const Text('A gyakorlás megszakad.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Mégse')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Kilépés')),
        ],
      ),
    );
    if (quit == true && mounted) Navigator.of(context).pop();
  }
}
