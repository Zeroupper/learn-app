import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Daily "keep the streak alive" reminder.
const _hour = 19;
const _minute = 0;

const _messages = [
  'Pár perc tanulás ma is — és a sorozat él tovább! 💪',
  'Egy kör szókártya, és mehet a pipa a mai napra. ✅',
  'A nyelvtanulás a kitartásról szól. Ne hagyd ki a mai napot! 🔥',
  'Öt perc most többet ér, mint egy óra „majd holnap”. ⏱️',
  'Ma is közelebb kerülhetsz a folyékony angolhoz. 🚀',
  'A sorozatod vár rád — gyere, tanulj egy kicsit! 📚',
  'Kis lépések, nagy eredmény. Kezdjük el a mai kört! 🌱',
];

/// Today at [_hour]:[_minute], or tomorrow if that moment already passed —
/// and never today when [lastActivity] shows the day is already done, so the
/// nudge only lands on days the streak actually needs saving.
tz.TZDateTime nextReminder(tz.TZDateTime now, {DateTime? lastActivity}) {
  var next =
      tz.TZDateTime(now.location, now.year, now.month, now.day, _hour, _minute);
  if (!next.isAfter(now) ||
      (lastActivity != null &&
          lastActivity.year == now.year &&
          lastActivity.month == now.month &&
          lastActivity.day == now.day)) {
    next = tz.TZDateTime(
        now.location, now.year, now.month, now.day + 1, _hour, _minute);
  }
  return next;
}

/// Re-arm the reminder. Call after every completed exercise so today's pending
/// notification is replaced by tomorrow's.
Future<void> scheduleDailyStreakReminder({DateTime? lastActivity}) async {
  // ponytail: a missing plugin (widget tests, unsupported platform) must not
  // take the caller down — a reminder is nice to have, not load-bearing.
  try {
    await _schedule(lastActivity);
  } catch (_) {
    // no-op
  }
}

Future<void> _schedule(DateTime? lastActivity) async {
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  tzdata.initializeTimeZones();
  // ponytail: app is Hungarian-only, so hardcode the zone instead of pulling
  // in flutter_timezone. Swap to the plugin if it ever ships elsewhere.
  tz.setLocalLocation(tz.getLocation('Europe/Budapest'));

  final when =
      nextReminder(tz.TZDateTime.now(tz.local), lastActivity: lastActivity);

  // Repeats daily; the body is re-randomised every app launch, so the message
  // rotates as long as the app gets opened now and then.
  await plugin.zonedSchedule(
    id: 0,
    title: 'Ne szakadjon meg a sorozat! 🔥',
    body: _messages[when.day % _messages.length],
    scheduledDate: when,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_streak',
        'Napi emlékeztető',
        channelDescription: 'Napi emlékeztető a tanulási sorozat megtartására',
      ),
    ),
    // ponytail: inexact avoids the SCHEDULE_EXACT_ALARM permission dance —
    // a study nudge does not need to land on the exact minute.
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
