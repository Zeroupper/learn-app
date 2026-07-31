import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/data/app_database.dart';
import 'package:learn_app/data/settings_repository.dart';
import 'package:learn_app/theme.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<SettingsRepository> freshSettings() async {
    await databaseFactory.deleteDatabase(inMemoryDatabasePath);
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options:
          OpenDatabaseOptions(version: 1, onCreate: AppDatabase.createSchema),
    );
    return SettingsRepository(db);
  }

  test('an unset or unknown theme name falls back to the default', () {
    expect(AppTheme.byName(null), AppTheme.classic);
    expect(AppTheme.byName('disco'), AppTheme.classic);
    expect(AppTheme.byName('rock70'), AppTheme.rock70);
  });

  test('the choice survives a restart', () async {
    final settings = await freshSettings();
    await ThemeChoice(settings, AppTheme.classic).set(AppTheme.rock70);

    // What the next launch would read back.
    expect(AppTheme.byName(await settings.themeName()), AppTheme.rock70);
  });

  test('each theme yields a light and a dark scheme of the right brightness',
      () async {
    final choice = ThemeChoice(await freshSettings(), AppTheme.classic);
    for (final theme in AppTheme.values) {
      await choice.set(theme);
      expect(choice.light.colorScheme.brightness, Brightness.light);
      expect(choice.dark.colorScheme.brightness, Brightness.dark);
    }
  });

  test('rock is a warm palette, distinct from the classic one', () async {
    final choice = ThemeChoice(await freshSettings(), AppTheme.classic);
    final classic = choice.light.colorScheme.primary;

    await choice.set(AppTheme.rock70);
    final rock = choice.light.colorScheme;

    expect(rock.primary, isNot(classic));
    // Burnt orange: red-dominant, not the blue-dominant default.
    expect(rock.primary.r, greaterThan(rock.primary.b));
    expect(rock.tertiary.g, greaterThan(rock.tertiary.b)); // avocado
  });

  test('themes can be interpolated, in both directions and at every step', () async {
    // Regression: a bare `TextStyle(...)` in a theme defaults to inherit:true,
    // and Flutter cannot lerp that against Material's inherit:false defaults.
    // Switching themes threw out of TextStyle.lerp partway through the
    // animation. ThemeData.lerp is that exact call, without the widget tree.
    final choice = ThemeChoice(await freshSettings(), AppTheme.classic);

    final themes = <ThemeData>[];
    for (final theme in AppTheme.values) {
      await choice.set(theme);
      themes..add(choice.light)..add(choice.dark);
    }

    for (final from in themes) {
      for (final to in themes) {
        if (from.brightness != to.brightness) continue; // never lerped in app
        for (final step in [0.0, 0.01, 0.25, 0.5, 0.75, 0.99, 1.0]) {
          expect(() => ThemeData.lerp(from, to, step), returnsNormally,
              reason: 'lerp failed at t=$step');
        }
      }
    }
  });

  test('no component text style is set in one theme but not the other', () async {
    // The root cause, asserted directly. ThemeData.textTheme styles are
    // inherit:true, while a component style left null falls back to
    // Material's resolved default, which is inherit:false. Defining one on
    // only one theme means the two cannot be interpolated, and the app throws
    // partway through the switch.
    final choice = ThemeChoice(await freshSettings(), AppTheme.classic);

    Map<String, TextStyle?> componentStyles(ThemeData t) => {
          'appBar title': t.appBarTheme.titleTextStyle,
          'appBar toolbar': t.appBarTheme.toolbarTextStyle,
          'filled button': t.filledButtonTheme.style?.textStyle
              ?.resolve(const <WidgetState>{}),
          'outlined button': t.outlinedButtonTheme.style?.textStyle
              ?.resolve(const <WidgetState>{}),
          'text button': t.textButtonTheme.style?.textStyle
              ?.resolve(const <WidgetState>{}),
          'elevated button': t.elevatedButtonTheme.style?.textStyle
              ?.resolve(const <WidgetState>{}),
        };

    for (final brightness in [Brightness.light, Brightness.dark]) {
      final perTheme = <AppTheme, Map<String, TextStyle?>>{};
      for (final theme in AppTheme.values) {
        await choice.set(theme);
        perTheme[theme] = componentStyles(
            brightness == Brightness.light ? choice.light : choice.dark);
      }

      for (final name in perTheme.values.first.keys) {
        final defined = {
          for (final e in perTheme.entries) e.key: e.value[name] != null,
        };
        expect(defined.values.toSet().length, 1,
            reason: '$name is defined in some themes but not others '
                '($brightness): $defined');
      }
    }
  });

  test('switching notifies listeners so the app repaints', () async {
    final choice = ThemeChoice(await freshSettings(), AppTheme.classic);
    var notified = 0;
    choice.addListener(() => notified++);

    await choice.set(AppTheme.rock70);
    expect(notified, 1);

    await choice.set(AppTheme.rock70); // same value, no repaint needed
    expect(notified, 1);
  });
}
