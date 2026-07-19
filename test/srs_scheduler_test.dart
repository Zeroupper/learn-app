import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/services/srs_scheduler.dart';

void main() {
  final now = DateTime(2026, 1, 1, 12);
  ReviewState fresh() =>
      const ReviewState(wordId: 1, direction: Direction.enToHu);

  test('interval progression 1 -> 6 -> EF-scaled', () {
    var s = SrsScheduler.applyReview(fresh(), 5, now);
    expect(s.repetitions, 1);
    expect(s.intervalDays, 1);

    s = SrsScheduler.applyReview(s, 5, now);
    expect(s.repetitions, 2);
    expect(s.intervalDays, 6);

    final efBefore = s.easeFactor;
    s = SrsScheduler.applyReview(s, 5, now);
    expect(s.repetitions, 3);
    expect(s.intervalDays, (6 * s.easeFactor).round());
    expect(s.easeFactor, greaterThan(efBefore)); // q=5 raises EF
  });

  test('ease factor floors at 1.3 after repeated poor grades', () {
    var s = fresh();
    for (var i = 0; i < 20; i++) {
      s = SrsScheduler.applyReview(s, 3, now);
    }
    expect(s.easeFactor, greaterThanOrEqualTo(1.3));
    expect(s.easeFactor, closeTo(1.3, 1e-9));
  });

  test('wrong answer resets repetitions and interval, adds a lapse', () {
    var s = SrsScheduler.applyReview(fresh(), 5, now); // rep 1
    s = SrsScheduler.applyReview(s, 5, now); // rep 2
    final lapsed = SrsScheduler.applyReview(s, 1, now);
    expect(lapsed.repetitions, 0);
    expect(lapsed.intervalDays, 0);
    expect(lapsed.lapses, 1);
    expect(lapsed.dueAt, now.add(SrsScheduler.relapseDelay));
  });

  test('almost (q=4) still passes', () {
    final s = SrsScheduler.applyReview(fresh(), 4, now);
    expect(s.repetitions, 1);
    expect(s.intervalDays, 1);
  });

  test('due date set interval days ahead on pass', () {
    final s = SrsScheduler.applyReview(fresh(), 5, now);
    expect(s.dueAt, now.add(const Duration(days: 1)));
  });
}
