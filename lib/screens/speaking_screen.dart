import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/settings_repository.dart';
import '../models/vocab_word.dart';
import '../services/tts_service.dart';

enum _WordStatus { pending, correct, wrong }

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen>
    with SingleTickerProviderStateMixin {
  static const _progressKey = 'speaking_progress';
  static const _promoteEvery = 10; // clean nails in a row to level up
  static const _failToDrop = 2; // failed attempts on a sentence to drop a level

  final SpeechToText _stt = SpeechToText();
  late final TtsService _tts;
  late final SettingsRepository _settings;
  late final AnimationController _flame;

  bool _celebrating = false;
  String _celebrateText = '';
  Timer? _celebrateTimer;

  Map<CefrLevel, List<String>> _byLevel = const {};
  final Map<CefrLevel, int> _ptr = {
    CefrLevel.a1: 0,
    CefrLevel.a2: 0,
    CefrLevel.b1: 0,
  };
  CefrLevel _level = CefrLevel.a1;
  bool _promotePending = false;

  bool _loaded = false;
  bool _available = false;
  bool _listening = false;
  String _heard = '';
  int _attempts = 0;
  bool? _correct;
  int _streak = 0;
  int _bestStreak = 0;

  List<String> get _pool => _byLevel[_level] ?? const [];
  String get _target =>
      _pool.isEmpty ? '' : _pool[_ptr[_level]! % _pool.length];
  bool get _revealAvailable => _attempts >= _failToDrop;

  CefrLevel? _nextLevel(CefrLevel l) => switch (l) {
        CefrLevel.a1 => CefrLevel.a2,
        CefrLevel.a2 => CefrLevel.b1,
        CefrLevel.b1 => null,
      };
  CefrLevel? _prevLevel(CefrLevel l) => switch (l) {
        CefrLevel.a1 => null,
        CefrLevel.a2 => CefrLevel.a1,
        CefrLevel.b1 => CefrLevel.a2,
      };

  @override
  void initState() {
    super.initState();
    _tts = context.read<TtsService>();
    _settings = context.read<SettingsRepository>();
    _flame = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650))
      ..repeat(reverse: true);
    _load();
  }

  Future<void> _load() async {
    final raw =
        await rootBundle.loadString('assets/data/speaking_sentences.json');
    final byLevel = <CefrLevel, List<String>>{
      CefrLevel.a1: [],
      CefrLevel.a2: [],
      CefrLevel.b1: [],
    };
    for (final e in jsonDecode(raw) as List) {
      byLevel[CefrLevel.fromString(e['level'] as String)]!
          .add(e['text'] as String);
    }
    _bestStreak = await _settings.speakingBest();
    final saved = await _settings.get(_progressKey);
    if (saved != null) {
      try {
        final j = jsonDecode(saved) as Map<String, dynamic>;
        _level = CefrLevel.fromString(j['level'] as String? ?? 'a1');
        for (final l in CefrLevel.values) {
          _ptr[l] = (j[l.name] as num?)?.toInt() ?? 0;
        }
      } catch (_) {/* start fresh */}
    }
    final available = await _stt.initialize(
      onStatus: (s) {
        if (s == 'done' || s == 'notListening') {
          if (mounted) setState(() => _listening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _listening = false);
      },
    );
    if (!mounted) return;
    setState(() {
      _byLevel = byLevel;
      _available = available;
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _celebrateTimer?.cancel();
    _flame.dispose();
    _stt.cancel();
    _tts.stop();
    super.dispose();
  }

  void _celebrate(String text) {
    _celebrateTimer?.cancel();
    setState(() {
      _celebrating = true;
      _celebrateText = text;
    });
    _celebrateTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _celebrating = false);
    });
  }

  Future<void> _saveProgress() => _settings.set(
      _progressKey,
      jsonEncode({
        'level': _level.name,
        for (final l in CefrLevel.values) l.name: _ptr[l],
      }));

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r"[^a-z0-9'\s]"), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  List<_WordStatus> _wordStatuses() {
    final t = _norm(_target).split(' ');
    final h = _norm(_heard).trim();
    final hw = h.isEmpty ? <String>[] : h.split(' ');
    return [
      for (var i = 0; i < t.length; i++)
        if (i >= hw.length)
          _WordStatus.pending
        else if (hw[i] == t[i])
          _WordStatus.correct
        else
          _WordStatus.wrong
    ];
  }

  bool _matches(String heard, String target) {
    final h = _norm(heard);
    final t = _norm(target);
    if (h == t) return true;
    final tw = t.split(' ');
    var i = 0;
    for (final w in h.split(' ')) {
      if (i < tw.length && w == tw[i]) i++;
    }
    return i == tw.length;
  }

  Future<void> _toggleMic() async {
    if (!_available) return;
    if (_listening) {
      await _stt.stop();
      return;
    }
    setState(() {
      _heard = '';
      _correct = null;
      _listening = true;
    });
    await _stt.listen(
      onResult: (r) {
        if (!_listening) return;
        setState(() => _heard = r.recognizedWords);
        if (_wordStatuses().every((s) => s == _WordStatus.correct)) {
          _succeed();
        } else if (r.finalResult) {
          _evaluate();
        }
      },
      listenOptions: SpeechListenOptions(
        localeId: 'en_US',
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _succeed() async {
    if (_correct == true) return;
    final nailed = _attempts == 0;
    setState(() {
      _correct = true;
      _listening = false;
    });
    await _stt.stop();
    _tts.praise();
    _registerSuccess(nailed);
  }

  void _evaluate() {
    final ok = _matches(_heard, _target);
    setState(() {
      _listening = false;
      _correct = ok;
      if (!ok) {
        _attempts++;
        _streak = 0; // a miss puts the fire out
      }
    });
    if (ok) {
      _tts.praise();
      _registerSuccess(_attempts == 0);
    } else if (_attempts >= _failToDrop && _prevLevel(_level) != null) {
      _demote();
    }
  }

  void _registerSuccess(bool nailed) {
    if (!nailed) return;
    setState(() {
      _streak++;
      if (_streak > _bestStreak) {
        _bestStreak = _streak;
        _settings.setSpeakingBest(_bestStreak);
      }
    });
    if (_streak % _promoteEvery == 0 && _nextLevel(_level) != null) {
      _promotePending = true;
      _celebrate('🎉 SZINTLÉPÉS!\n${_nextLevel(_level)!.label} jön');
    } else if (_streak >= 3) {
      _celebrate('🔥 $_streak');
    }
  }

  void _demote() {
    final pl = _prevLevel(_level);
    if (pl == null) return;
    setState(() {
      _level = pl;
      _attempts = 0;
      _correct = null;
      _heard = '';
    });
    _saveProgress();
    _snack('Nehéz volt — vissza ${pl.label} szintre.');
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));

  /// Only reachable after a success — moves to the next sentence, applying a
  /// pending level-up.
  Future<void> _next() async {
    await _stt.cancel();
    if (!mounted) return;
    setState(() {
      if (_pool.isNotEmpty) _ptr[_level] = _ptr[_level]! + 1; // completed one
      if (_promotePending) {
        final nl = _nextLevel(_level);
        if (nl != null) _level = nl;
        _promotePending = false;
      }
      _attempts = 0;
      _correct = null;
      _heard = '';
    });
    await _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beszéd')),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _fireBar(),
                const SizedBox(height: 12),
                _progress(),
                const SizedBox(height: 16),
                if (!_available)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'A beszédfelismerés nem érhető el. Engedélyezd a '
                      'mikrofont, és telepítsd a Google beszédfelismerőt.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Text('Mondd ki hangosan:',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _highlightedSentence()),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          tooltip: 'Meghallgatás',
                          onPressed: () => _tts.speak(_target),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: IconButton.filled(
                    iconSize: 48,
                    isSelected: _listening,
                    onPressed: _available ? _toggleMic : null,
                    icon: Icon(_listening ? Icons.stop : Icons.mic),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _listening ? 'Beszélj most…' : 'Koppints a mikrofonra',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (_heard.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Ezt hallottam:',
                      style: Theme.of(context).textTheme.labelLarge),
                  Text('„$_heard”'),
                ],
                if (_correct == true) ...[
                  const SizedBox(height: 16),
                  const _Banner(true, 'Helyes! Jól ejtetted ki.'),
                ],
                if (_correct == false) ...[
                  const SizedBox(height: 16),
                  _Banner(false, 'Nem egyezik. Próbáld újra. ($_attempts/$_failToDrop)'),
                ],
                if (_revealAvailable) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Helyes kiejtés',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          const Text('Hallgasd meg lassan, és ismételd:'),
                          const SizedBox(height: 8),
                          FilledButton.tonalIcon(
                            onPressed: () => _tts.speak(_target, rate: 0.3),
                            icon: const Icon(Icons.slow_motion_video),
                            label: const Text('Lassú kiejtés'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                // "Next" appears only once the sentence is nailed.
                if (_correct == true) ...[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Következő mondat'),
                  ),
                ],
              ],
            ),
              if (_celebrating) Positioned.fill(child: _celebration()),
            ]),
    );
  }

  Widget _fireBar() {
    final s = _streak;
    final color = s == 0
        ? Colors.grey
        : s < 3
            ? Colors.orange
            : s < 5
                ? Colors.deepOrange
                : Colors.red;
    final size = (28 + s.clamp(0, 12) * 3).toDouble();
    final atTop = _nextLevel(_level) == null;
    final toNext = _promoteEvery - (s % _promoteEvery);
    final flames = s >= 10 ? 3 : s >= 5 ? 2 : 1;
    return Card(
      color: s >= 3 ? color.withValues(alpha: 0.10) : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            for (var i = 0; i < flames; i++)
              _animatedFlame(size, color, i / flames, active: s > 0),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    s == 0 ? 'Kezdj sorozatot!' : 'Zsinórban: $s',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: s > 0 ? color : null),
                  ),
                  Text(
                    atTop
                        ? 'Rekord: $_bestStreak · Legmagasabb szint 🏆'
                        : 'Rekord: $_bestStreak · még $toNext a szintlépésig',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedFlame(double size, Color color, double phase,
      {required bool active}) {
    return AnimatedBuilder(
      animation: _flame,
      builder: (_, child) {
        final t = (_flame.value + phase) % 1.0;
        final wave = math.sin(t * 2 * math.pi);
        final scale = active ? 1.0 + 0.20 * wave : 1.0;
        return Transform.translate(
          offset: Offset(0, active ? -2 * wave : 0),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Icon(Icons.local_fire_department, color: color, size: size),
    );
  }

  Widget _celebration() {
    return IgnorePointer(
      child: Center(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(_celebrateText),
          tween: Tween(begin: 0.5, end: 1.0),
          duration: const Duration(milliseconds: 450),
          curve: Curves.elasticOut,
          builder: (_, v, child) =>
              Transform.scale(scale: v, child: Opacity(opacity: v.clamp(0, 1), child: child)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.6),
                    blurRadius: 30,
                    spreadRadius: 4),
              ],
            ),
            child: Text(
              _celebrateText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _progress() {
    var overallDone = 0;
    var overallTotal = 0;
    final rows = <Widget>[];
    for (final level in CefrLevel.values) {
      final count = (_byLevel[level] ?? const []).length;
      if (count == 0) continue;
      final done = (_ptr[level] ?? 0).clamp(0, count);
      overallDone += done;
      overallTotal += count;
      rows.add(Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            SizedBox(
                width: 32,
                child: Text(level.label,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: level == _level
                            ? Theme.of(context).colorScheme.primary
                            : null))),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                    value: done / count, minHeight: 7),
              ),
            ),
            const SizedBox(width: 8),
            Text('$done/$count'),
          ],
        ),
      ));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Haladás — most ${_level.label} szint',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('$overallDone / $overallTotal'),
              ],
            ),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _highlightedSentence() {
    final words = _target.split(RegExp(r'\s+'));
    final statuses = _wordStatuses();
    final green = Colors.green.shade600;
    final red = Colors.red.shade600;
    return Wrap(
      spacing: 6,
      runSpacing: 2,
      children: [
        for (var i = 0; i < words.length; i++)
          Text(
            words[i],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: switch (
                  i < statuses.length ? statuses[i] : _WordStatus.pending) {
                _WordStatus.correct => green,
                _WordStatus.wrong => red,
                _WordStatus.pending => null,
              },
            ),
          ),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  final bool ok;
  final String text;
  const _Banner(this.ok, this.text);

  @override
  Widget build(BuildContext context) {
    final color = ok ? Colors.green : Colors.red;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Icon(ok ? Icons.check_circle : Icons.cancel, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ]),
    );
  }
}
