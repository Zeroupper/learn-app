import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';

/// Speaks English text via the platform TTS engine (Google TTS on Android).
/// Free, offline, no API key. Graceful no-op if the engine/voice is missing.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  final Random _rng = Random();
  bool _ready = false;

  static const _praises = [
    'Nice job!',
    'Well done!',
    'Amazing!',
    'Great work!',
    'Perfect!',
    'Excellent!',
    'You nailed it!',
    'Fantastic!',
    'Awesome!',
    'Brilliant!',
  ];

  /// Speaks a short, upbeat praise phrase (for correct answers).
  Future<void> praise() =>
      speak(_praises[_rng.nextInt(_praises.length)], rate: 0.5);

  Future<void> _ensure() async {
    if (_ready) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45); // clearer for learners
    _ready = true;
  }

  /// Stops any current utterance, then speaks [text]. Optional [rate] overrides
  /// the speaking speed (0.0–1.0; ~0.45 is a clear default). Silently ignores
  /// errors (e.g. no TTS engine installed) so the UI never breaks.
  Future<void> speak(String text, {double? rate}) async {
    if (text.trim().isEmpty) return;
    try {
      await _ensure();
      if (rate != null) await _tts.setSpeechRate(rate);
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // no-op: missing engine/voice shouldn't crash the app
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
