import 'package:flutter/foundation.dart';

import '../data/srs_repository.dart';
import '../models/review_state.dart';
import '../models/vocab_word.dart';
import '../services/answer_checker.dart';
import '../services/session_builder.dart';
import '../services/srs_scheduler.dart';

enum StudyPhase { prompting, correct, almost, wrong, finished }

typedef LoadState = Future<ReviewState> Function(int wordId, Direction dir);
typedef SaveReview = Future<void> Function(ReviewState updated, int quality);

/// The word + direction currently on screen, with derived prompt/answer text.
class StudyPrompt {
  final VocabWord word;
  final Direction direction;
  const StudyPrompt(this.word, this.direction);

  bool get targetIsHu => direction == Direction.enToHu;
  String get promptText => targetIsHu ? word.en : word.hu.first;
  String get answerText => targetIsHu ? word.hu.join(', ') : word.en;
  List<String> get accepted =>
      targetIsHu ? word.hu : [word.en, ...word.enAccepted];

  /// The English string to feed TTS (always the English side of the card).
  String get englishText => word.en;
}

class _CardStatus {
  final SessionCard card;
  bool hasFailed = false;
  bool resolved = false;
  _CardStatus(this.card);
}

/// Duolingo-style study loop. Persists exactly one SM-2 review per card per
/// session (quality decided by the first-attempt outcome and whether the card
/// was ever failed in-session).
class StudyController extends ChangeNotifier {
  final List<SessionCard> _queue;
  final VocabWord Function(int id) _lookup;
  final LoadState _loadState;
  final SaveReview _saveReview;
  final DateTime Function() _clock;

  // ponytail: callbacks (not a repo interface) keep this DB-free and unit-testable.
  final Map<String, _CardStatus> _status = {};
  final Set<String> _resolved = {};

  int _index = 0;
  StudyPhase _phase = StudyPhase.prompting;
  String _lastInput = '';
  int _correct = 0;
  int _wrong = 0;

  StudyController({
    required List<SessionCard> queue,
    required VocabWord Function(int id) lookup,
    required LoadState loadState,
    required SaveReview saveReview,
    DateTime Function()? clock,
  })  : _queue = List.of(queue),
        _lookup = lookup, // ignore: prefer_initializing_formals
        _loadState = loadState, // ignore: prefer_initializing_formals
        _saveReview = saveReview, // ignore: prefer_initializing_formals
        _clock = clock ?? DateTime.now {
    for (final c in _queue) {
      _status.putIfAbsent(c.key, () => _CardStatus(c));
    }
  }

  /// Wires persistence to a real [SrsRepository].
  factory StudyController.withRepo({
    required List<SessionCard> queue,
    required VocabWord Function(int id) lookup,
    required SrsRepository srs,
    DateTime Function()? clock,
  }) {
    return StudyController(
      queue: queue,
      lookup: lookup,
      clock: clock,
      loadState: srs.stateFor,
      saveReview: (updated, quality) =>
          srs.save(updated, quality: quality, reviewedAt: updated.lastReviewedAt),
    );
  }

  StudyPhase get phase => _phase;
  bool get isFinished => _phase == StudyPhase.finished;
  String get lastInput => _lastInput;
  int get correctCount => _correct;
  int get wrongCount => _wrong;
  int get totalCards => _status.length;
  double get progress =>
      totalCards == 0 ? 1 : _resolved.length / totalCards;

  StudyPrompt? get prompt {
    if (_index >= _queue.length) return null;
    final c = _queue[_index];
    return StudyPrompt(_lookup(c.wordId), c.direction);
  }

  Future<void> check(String input) async {
    if (_phase != StudyPhase.prompting) return;
    final p = prompt;
    if (p == null) return;
    final key = _queue[_index].key;
    _lastInput = input;
    final grade =
        AnswerChecker.check(input, p.accepted, targetIsHu: p.targetIsHu);

    if (grade == Grade.wrong) {
      _status[key]!.hasFailed = true;
      _wrong++;
      _phase = StudyPhase.wrong;
    } else {
      final q = _status[key]!.hasFailed ? 3 : (grade == Grade.almost ? 4 : 5);
      await _persist(_queue[_index], q);
      _status[key]!.resolved = true;
      _resolved.add(key);
      _correct++;
      _phase = grade == Grade.almost ? StudyPhase.almost : StudyPhase.correct;
    }
    notifyListeners();
  }

  /// Advance after a banner ("Tovább" for pass, "Megértettem" for wrong).
  Future<void> proceed() async {
    if (_phase == StudyPhase.wrong) {
      final card = _queue[_index];
      final pos = SessionBuilder.reinsertPosition(_index, _queue.length);
      _queue.insert(pos, card);
    }
    _index++;
    if (_index >= _queue.length) {
      await _finish();
    } else {
      _phase = StudyPhase.prompting;
    }
    notifyListeners();
  }

  Future<void> _finish() async {
    for (final s in _status.values) {
      if (s.hasFailed && !s.resolved) {
        await _persist(s.card, 1);
      }
    }
    _phase = StudyPhase.finished;
  }

  Future<void> _persist(SessionCard card, int quality) async {
    final state = await _loadState(card.wordId, card.direction);
    final updated = SrsScheduler.applyReview(state, quality, _clock());
    await _saveReview(updated, quality);
  }
}
