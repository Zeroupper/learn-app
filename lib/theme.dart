import 'package:flutter/material.dart';

import 'data/settings_repository.dart';

/// Selectable app themes.
enum AppTheme {
  classic('Alap', 'Tiszta, semleges indigó'),
  rock70('Rock \'70', 'Égetett narancs, arany, avokádó');

  const AppTheme(this.label, this.blurb);

  final String label;
  final String blurb;

  static AppTheme byName(String? name) =>
      values.firstWhere((t) => t.name == name, orElse: () => classic);
}

/// The chosen theme, persisted in settings. [LearnApp] watches this and
/// repaints the whole app the moment it changes.
class ThemeChoice extends ValueNotifier<AppTheme> {
  ThemeChoice(this._settings, super.initial);

  final SettingsRepository _settings;

  Future<void> set(AppTheme theme) async {
    value = theme;
    await _settings.set(SettingsRepository.keyTheme, theme.name);
  }

  ThemeData get light => switch (value) {
        AppTheme.classic => _classic(Brightness.light),
        AppTheme.rock70 => _rock(Brightness.light),
      };

  ThemeData get dark => switch (value) {
        AppTheme.classic => _classic(Brightness.dark),
        AppTheme.rock70 => _rock(Brightness.dark),
      };
}

ThemeData _classic(Brightness brightness) => ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: brightness),
      useMaterial3: true,
    );

// A 1970s record-sleeve palette: burnt orange, harvest gold, avocado, on
// cream or near-black walnut.
const _burntOrange = Color(0xFFC1440E);
const _harvestGold = Color(0xFFE0A526);
const _avocado = Color(0xFF6B7F3A);
const _cream = Color(0xFFF4E7CE);
const _walnut = Color(0xFF1C1310);

ThemeData _rock(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: _burntOrange,
    brightness: brightness,
    // Pinned, not derived: Material's harmonisation washes the era out.
    primary: dark ? _harvestGold : _burntOrange,
    secondary: dark ? _burntOrange : _avocado,
    tertiary: _avocado,
    surface: dark ? _walnut : _cream,
  );

  // Chunky and rounded — the decade did not do sharp corners.
  const radius = 18.0;
  final base = ThemeData(colorScheme: scheme, useMaterial3: true);
  final text = base.textTheme;

  // No component below sets a `textStyle`/`titleTextStyle`. The classic theme
  // leaves those null, so its widgets fall back to Material's resolved
  // defaults, which are inherit:false — while anything built from
  // `textTheme` here is inherit:true. Flutter cannot lerp across that, so
  // setting one on only one theme throws mid theme-switch. Weight is carried
  // by `textTheme` instead, which both themes define the same way.
  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium
          ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
      titleLarge: text.titleLarge
          ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? _walnut : _burntOrange,
      foregroundColor: dark ? _harvestGold : _cream,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF2A1E19) : const Color(0xFFFBF3E4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: scheme.primary.withValues(alpha: 0.35)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: scheme.primary.withValues(alpha: 0.45)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? const Color(0xFF241A15) : const Color(0xFFEBD9B8),
      indicatorColor: scheme.primary.withValues(alpha: 0.28),
      indicatorShape: const StadiumBorder(),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.5)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.primary.withValues(alpha: 0.25),
      thickness: 1.5,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
  );
}
