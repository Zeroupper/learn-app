enum CefrLevel {
  a1,
  a2,
  b1;

  static CefrLevel fromString(String s) =>
      CefrLevel.values.firstWhere((l) => l.name == s.toLowerCase());

  String get label => name.toUpperCase();
}

/// A single vocabulary entry loaded from the bundled asset. Immutable.
class VocabWord {
  final int id;
  final String en;
  final List<String> enAccepted; // extra accepted English answers (HU->EN)
  final List<String> hu; // accepted Hungarian answers (EN->HU)
  final CefrLevel level;
  final String pos;
  final String? exampleEn;
  final String? exampleHu;

  const VocabWord({
    required this.id,
    required this.en,
    required this.enAccepted,
    required this.hu,
    required this.level,
    required this.pos,
    this.exampleEn,
    this.exampleHu,
  });

  factory VocabWord.fromJson(Map<String, dynamic> j) => VocabWord(
        id: j['id'] as int,
        en: j['en'] as String,
        enAccepted: (j['en_accepted'] as List?)?.cast<String>() ?? const [],
        hu: (j['hu'] as List).cast<String>(),
        level: CefrLevel.fromString(j['level'] as String),
        pos: j['pos'] as String? ?? '',
        exampleEn: j['example_en'] as String?,
        exampleHu: j['example_hu'] as String?,
      );
}
