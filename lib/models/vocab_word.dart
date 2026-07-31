import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocab_word.freezed.dart';
part 'vocab_word.g.dart';

enum CefrLevel {
  a1,
  a2,
  b1;

  static CefrLevel fromString(String s) =>
      CefrLevel.values.firstWhere((l) => l.name == s.toLowerCase());

  String get label => name.toUpperCase();
}

/// A single vocabulary entry loaded from the bundled asset. Immutable.
@freezed
abstract class VocabWord with _$VocabWord {
  const factory VocabWord({
    required int id,
    required String en,

    /// Extra accepted English answers (HU->EN).
    @Default(<String>[]) List<String> enAccepted,

    /// Accepted Hungarian answers (EN->HU).
    required List<String> hu,
    required CefrLevel level,
    @Default('') String pos,
    String? exampleEn,
    String? exampleHu,
  }) = _VocabWord;

  factory VocabWord.fromJson(Map<String, dynamic> json) =>
      _$VocabWordFromJson(json);
}
