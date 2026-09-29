import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/settings_repository.dart';
import '../models/vocab_word.dart';
import '../services/tts_service.dart';

// ---------------------------------------------------------------------------
// Matching. Pure functions, no widgets — this is the part worth unit testing,
// and the screen derives *everything* from it: the verdict and the per-word
// colouring both come out of one alignment, so they can never disagree.
// ---------------------------------------------------------------------------

/// Lowercase, strip punctuation, collapse whitespace, split. Empty in, empty
/// out — never a `['']` that would count as a spoken word.
List<String> _words(String s) {
  final n = s
      .toLowerCase()
      .replaceAll(RegExp(r"[^a-z0-9'\s]"), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return n.isEmpty ? const [] : n.split(' ');
}

/// For each word of [target], did the learner say it?
///
/// This is a longest-common-subsequence alignment, which buys two things a
/// simple word-by-word comparison does not: filler the recogniser invents is
/// ignored, and one mangled word in the middle costs exactly that word — a
/// greedy walk would stall there and call the whole rest of the sentence
/// missing.
List<bool> matchedWords(String heard, String target) {
  final tw = _words(target);
  final hw = _words(heard);
  final matched = List.filled(tw.length, false);
  if (tw.isEmpty || hw.isEmpty) return matched;

  // dp[i][j] = length of the best alignment of hw[i..] against tw[j..].
  // Built from the end so the walk below can go forwards and record hits.
  final dp = List.generate(hw.length + 1, (_) => List.filled(tw.length + 1, 0));
  for (var i = hw.length - 1; i >= 0; i--) {
    for (var j = tw.length - 1; j >= 0; j--) {
      dp[i][j] = hw[i] == tw[j]
          ? dp[i + 1][j + 1] + 1
          : math.max(dp[i + 1][j], dp[i][j + 1]);
    }
  }
  var i = 0, j = 0;
  while (i < hw.length && j < tw.length) {
    if (hw[i] == tw[j]) {
      matched[j] = true;
      i++;
      j++;
    } else if (dp[i + 1][j] >= dp[i][j + 1]) {
      i++; // this heard word is filler
    } else {
      j++; // this target word never came out
    }
  }
  return matched;
}

/// How many words a sentence may lose and still pass. Recognition mangles a
/// word often enough that one slip should not fail a fluent read — but not on
/// "Are you cold?", where one word is a third of the answer.
int allowedMissesFor(String target) => _words(target).length >= 5 ? 1 : 0;

/// Did [heard] cover [target], give or take the slack [allowedMissesFor]
/// grants that sentence?
bool speechMatches(String heard, String target) =>
    matchedWords(heard, target).where((m) => !m).length <=
    allowedMissesFor(target);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Where the current sentence stands. One field instead of the separate
/// "listening?" / "waiting for a result?" / "was it right?" flags that used to
/// drift apart whenever a recogniser callback arrived at an awkward moment.
enum _Phase {
  /// Mic off, nothing said yet for this sentence.
  idle,

  /// Mic live and a verdict is owed. Every recogniser callback checks for this
  /// phase, which is what stops a cancelled session from scoring the next
  /// sentence.
  listening,

  /// Judged correct — the "next sentence" button is showing.
  correct,

  /// Judged wrong — the learner can retry, and after enough tries skip.
  wrong,
}

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen>
    with SingleTickerProviderStateMixin {
  // --- tuning -------------------------------------------------------------
  static const _progressKey = 'speaking_progress';
  static const _promoteEvery = 10; // first-try successes in a row to level up
  static const _failToSkip = 3; // failures before the sentence can be skipped
  static const _failToDrop = 6; // failures before dropping a level

  // --- collaborators ------------------------------------------------------
  final SpeechToText _stt = SpeechToText();
  late final TtsService _tts;
  late final SettingsRepository _settings;

  /// Drives the flame icons in the streak bar.
  late final AnimationController _flame;

  // --- content ------------------------------------------------------------
  /// Every sentence, bucketed by level. Loaded once from the asset bundle.
  Map<CefrLevel, List<String>> _byLevel = const {};

  /// How far the learner has got in each level's list. Persisted.
  final Map<CefrLevel, int> _ptr = {
    CefrLevel.a1: 0,
    CefrLevel.a2: 0,
    CefrLevel.b1: 0,
  };

  /// The level being practised right now. Persisted.
  CefrLevel _level = CefrLevel.a1;

  /// A level-up is owed but held back until the learner taps "next", so the
  /// sentence does not change out from under the celebration.
  bool _levelUpPending = false;

  // --- session state ------------------------------------------------------
  /// False until the sentences and saved progress are in — gates the UI.
  bool _loaded = false;

  /// Whether the device has usable speech recognition at all.
  bool _available = false;

  /// See [_Phase]. The single source of truth for the listen cycle.
  _Phase _phase = _Phase.idle;

  /// The recogniser's latest transcript for this attempt, partial or final.
  String _heard = '';

  /// Failed attempts on the *current* sentence. Drives the skip button and the
  /// level drop; reset when the sentence changes.
  int _attempts = 0;

  // --- streak -------------------------------------------------------------
  /// Consecutive first-try successes. A miss or a skip puts it out.
  int _streak = 0;

  /// Best streak ever, persisted, shown as the record to beat.
  int _bestStreak = 0;

  // --- celebration overlay ------------------------------------------------
  bool _celebrating = false;
  String _celebrateText = '';
  Timer? _celebrateTimer;

  // --- derived ------------------------------------------------------------
  List<String> get _pool => _byLevel[_level] ?? const [];
  String get _target =>
      _pool.isEmpty ? '' : _pool[_ptr[_level]! % _pool.length];
  bool get _listening => _phase == _Phase.listening;
  bool get _skipAvailable =>
      _phase != _Phase.correct && _attempts >= _failToSkip;

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

  // --- lifecycle ----------------------------------------------------------

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

  /// Reads the sentence list and saved progress, then wakes the recogniser.
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
      } catch (_) {/* corrupt save — start fresh */}
    }
    final available = await _stt.initialize(
      onStatus: _onStatus,
      onError: _onError,
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

  /// Saves which level and how far into each list the learner is.
  Future<void> _saveProgress() => _settings.set(
      _progressKey,
      jsonEncode({
        'level': _level.name,
        for (final l in CefrLevel.values) l.name: _ptr[l],
      }));

  // --- the listen cycle ---------------------------------------------------
  //
  // One rule: the microphone stopping ends the attempt. Nothing else scores.
  // Transcripts stream in and are only displayed; the moment the engine is no
  // longer listening — tapped off, silence timeout, or error — [_judge] runs
  // at once. The [_Phase.listening] check makes every later trigger a no-op,
  // so it is scored exactly once however many of them fire.

  /// Mic button. Starts an attempt, or ends one early when the learner is done
  /// talking and does not want to wait out the silence timeout.
  Future<void> _toggleMic() async {
    if (!_available) return;
    if (_listening) {
      // stop() flushes whatever the engine has into _heard and reports
      // "notListening", which judges. Judging here too costs nothing (the
      // phase guard) and covers an engine that goes quiet without saying so.
      await _stt.stop();
      _judge();
      return;
    }
    // SpeechToText is a singleton shared with DictationButton; initialize()
    // only registers listeners once, so reclaim them per attempt.
    _stt
      ..statusListener = _onStatus
      ..errorListener = _onError;
    setState(() {
      _heard = '';
      _phase = _Phase.listening;
    });
    await _stt.listen(
      onResult: _onResult,
      listenOptions: SpeechListenOptions(
        localeId: 'en_US',
        // A 16-word sentence read by a learner runs well past the old 15s cap,
        // which is what used to cut people off mid-speech. The mic is
        // tap-to-stop, so this is only a safety net.
        listenFor: const Duration(minutes: 2),
        // Silence needed to end an attempt — and therefore also how long the
        // verdict takes to appear once the learner stops talking. It only
        // starts counting after they stop making sound, so short is fine.
        pauseFor: const Duration(seconds: 3),
      ),
    );
  }

  /// A transcript, partial or final — displayed, never scored. A partial that
  /// happens to match must not end the attempt while the learner is still
  /// talking, and one that arrives after the verdict must not rewrite it.
  void _onResult(SpeechRecognitionResult r) {
    if (!mounted || !_listening) return;
    setState(() => _heard = r.recognizedWords);
  }

  /// The engine's own state changes — and the microphone going quiet is
  /// exactly what ends an attempt, so this scores it immediately.
  ///
  /// ponytail: judged on the newest transcript rather than waiting for the
  /// engine's final one, which can trail the stop signal. After a 3s silence
  /// the two are the same in practice, and waiting was the visible lag.
  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') _judge();
  }

  /// Recogniser failures. A badly mangled word comes back as "no match" with
  /// no transcript at all — that is a failed attempt, not a non-event, or the
  /// learner gets no feedback and never reaches the skip button.
  void _onError(SpeechRecognitionError e) {
    if (!mounted || !_listening) return;
    if (e.errorMsg == 'error_no_match' || e.errorMsg == 'error_speech_timeout') {
      _judge();
    } else {
      // Permission or engine trouble: not the learner's fault, so no attempt
      // is spent and the mic simply goes back to idle.
      setState(() => _phase = _Phase.idle);
      _snack('A beszédfelismerő hibázott (${e.errorMsg}).');
    }
  }

  /// Scores the attempt against the newest transcript. The only place
  /// [_phase] leaves [_Phase.listening], so calling it twice is harmless.
  void _judge() {
    if (!mounted || !_listening) return;
    final ok = speechMatches(_heard, _target);
    // Read before the counter moves: only a sentence nailed without a single
    // failed try extends the streak.
    final nailed = _attempts == 0;
    setState(() {
      _phase = ok ? _Phase.correct : _Phase.wrong;
      if (!ok) {
        _attempts++;
        _streak = 0; // a miss puts the fire out
      }
    });
    if (ok) {
      _tts.praise();
      if (nailed) _extendStreak();
    } else if (_attempts >= _failToDrop) {
      _demote();
    }
  }

  // --- scoring ------------------------------------------------------------

  /// Grows the streak, saves a new record, and celebrates milestones.
  void _extendStreak() {
    setState(() {
      _streak++;
      if (_streak > _bestStreak) {
        _bestStreak = _streak;
        _settings.setSpeakingBest(_bestStreak);
      }
    });
    if (_streak % _promoteEvery == 0 && _nextLevel(_level) != null) {
      _levelUpPending = true;
      _celebrate('🎉 SZINTLÉPÉS!\n${_nextLevel(_level)!.label} jön');
    } else if (_streak >= 3) {
      _celebrate('🔥 $_streak');
    }
  }

  /// Drops a level after [_failToDrop] failures, which also hands the learner
  /// a different (easier) sentence. No-op at A1 — there is nowhere to go, and
  /// the skip button is the way out there.
  void _demote() {
    final pl = _prevLevel(_level);
    if (pl == null) return;
    setState(() {
      _level = pl;
      _attempts = 0;
      _heard = '';
      _phase = _Phase.idle;
    });
    _saveProgress();
    _snack('Nehéz volt — vissza ${pl.label} szintre.');
  }

  /// Moves to the next sentence, applying any level-up earned on this one.
  Future<void> _next() async {
    await _stt.cancel();
    if (!mounted) return;
    setState(() {
      if (_pool.isNotEmpty) _ptr[_level] = _ptr[_level]! + 1;
      if (_levelUpPending) {
        final nl = _nextLevel(_level);
        if (nl != null) _level = nl;
        _levelUpPending = false;
      }
      _attempts = 0;
      _heard = '';
      _phase = _Phase.idle;
    });
    await _saveProgress();
  }

  /// Give up on a sentence that will not come out. Moves on like [_next], but
  /// the fire goes out.
  Future<void> _skip() async {
    setState(() => _streak = 0);
    await _next();
    if (mounted) _snack('Kihagyva — a sorozat nullázódott.');
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));

  /// Pops a message over the screen for a moment (streak milestones, level-up).
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

  // --- UI -----------------------------------------------------------------

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
                          Expanded(child: _sentence()),
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
                      _listening
                          ? 'Beszélj most… ha kész vagy, koppints'
                          : 'Koppints a mikrofonra',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (_heard.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Ezt hallottam:',
                        style: Theme.of(context).textTheme.labelLarge),
                    Text('„$_heard”'),
                  ],
                  if (_phase == _Phase.correct) ...[
                    const SizedBox(height: 16),
                    const _Banner(true, 'Helyes! Jól ejtetted ki.'),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _next,
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Következő mondat'),
                    ),
                  ],
                  if (_phase == _Phase.wrong) ...[
                    const SizedBox(height: 16),
                    _Banner(false,
                        'Nem egyezik. Próbáld újra. ($_attempts. próbálkozás)'),
                  ],
                  if (_skipAvailable) ...[
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: _skip,
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Kihagyom — a sorozat elszáll'),
                    ),
                  ],
                ],
              ),
              if (_celebrating) Positioned.fill(child: _celebration()),
            ]),
    );
  }

  /// The target sentence, each word green once the recogniser has heard it.
  /// Unheard words stay neutral while listening and turn red once the attempt
  /// has been judged wrong — same alignment the verdict used, so the colours
  /// can never contradict the banner.
  Widget _sentence() {
    final words = _target.trim().split(RegExp(r'\s+'));
    final matched = matchedWords(_heard, _target);
    final missColor = _phase == _Phase.wrong ? Colors.red.shade600 : null;
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
              color: i < matched.length && matched[i]
                  ? Colors.green.shade600
                  : missColor,
            ),
          ),
      ],
    );
  }

  /// Streak header: flames that grow and multiply with the run.
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
    final flames = s >= 10
        ? 3
        : s >= 5
            ? 2
            : 1;
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

  /// One flame, bobbing out of phase with its neighbours.
  Widget _animatedFlame(double size, Color color, double phase,
      {required bool active}) {
    return AnimatedBuilder(
      animation: _flame,
      builder: (_, child) {
        final wave = math.sin(((_flame.value + phase) % 1.0) * 2 * math.pi);
        return Transform.translate(
          offset: Offset(0, active ? -2 * wave : 0),
          child: Transform.scale(
              scale: active ? 1.0 + 0.20 * wave : 1.0, child: child),
        );
      },
      child: Icon(Icons.local_fire_department, color: color, size: size),
    );
  }

  /// Per-level completion bars.
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
                child:
                    LinearProgressIndicator(value: done / count, minHeight: 7),
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

  /// The pop-over shown on streak milestones and level-ups.
  Widget _celebration() {
    return IgnorePointer(
      child: Center(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(_celebrateText),
          tween: Tween(begin: 0.5, end: 1.0),
          duration: const Duration(milliseconds: 450),
          curve: Curves.elasticOut,
          builder: (_, v, child) => Transform.scale(
              scale: v, child: Opacity(opacity: v.clamp(0, 1), child: child)),
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
}

/// Green/red result strip under the mic.
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
