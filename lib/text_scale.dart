import 'package:flutter/foundation.dart';

import 'data/settings_repository.dart';

/// App-wide text scale factor, persisted in settings. The MaterialApp listens
/// to this and re-applies it live when the user moves the slider.
class TextScale extends ValueNotifier<double> {
  final SettingsRepository _settings;
  TextScale(this._settings, double initial) : super(initial);

  static const min = 0.9;
  static const max = 1.8;

  Future<void> set(double value) async {
    this.value = value;
    await _settings.set(
        SettingsRepository.keyTextScale, value.toStringAsFixed(2));
  }
}
