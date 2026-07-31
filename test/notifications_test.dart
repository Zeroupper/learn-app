import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/services/notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Budapest'));
  });

  tz.TZDateTime at(int day, int hour, int minute) =>
      tz.TZDateTime(tz.local, 2026, 7, day, hour, minute);

  test('before the reminder time → today', () {
    expect(nextReminder(at(30, 8, 0)), at(30, 19, 0));
  });

  test('after the reminder time → tomorrow', () {
    expect(nextReminder(at(30, 19, 1)), at(31, 19, 0));
  });

  test('exactly at the reminder time → tomorrow, never fires immediately', () {
    expect(nextReminder(at(30, 19, 0)), at(31, 19, 0));
  });

  test('rolls over the month boundary', () {
    expect(nextReminder(at(31, 22, 0)), tz.TZDateTime(tz.local, 2026, 8, 1, 19));
  });

  test('already studied today → skips to tomorrow', () {
    expect(
      nextReminder(at(30, 8, 0), lastActivity: DateTime(2026, 7, 30, 7, 30)),
      at(31, 19, 0),
    );
  });

  test('last studied yesterday → still fires today', () {
    expect(
      nextReminder(at(30, 8, 0), lastActivity: DateTime(2026, 7, 29, 20, 0)),
      at(30, 19, 0),
    );
  });

  test('studied today but past the reminder → tomorrow, not the day after', () {
    expect(
      nextReminder(at(30, 21, 0), lastActivity: DateTime(2026, 7, 30, 20, 0)),
      at(31, 19, 0),
    );
  });
}
