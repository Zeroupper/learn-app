import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/vocab_word.dart';

/// Loads the bundled vocabulary asset into memory once at startup.
class VocabRepository {
  final List<VocabWord> words;
  final Map<int, VocabWord> _byId;
  final Map<String, VocabWord> _byEn;
  final Map<String, Set<String>> _byHu;

  VocabRepository(this.words)
      : _byId = {for (final w in words) w.id: w},
        _byEn = {for (final w in words) w.en.toLowerCase(): w},
        _byHu = _reverseIndex(words);

  static Map<String, Set<String>> _reverseIndex(List<VocabWord> words) {
    final index = <String, Set<String>>{};
    for (final w in words) {
      for (final hu in w.hu) {
        (index[hu.toLowerCase()] ??= <String>{}).add(w.en);
      }
    }
    return index;
  }

  /// Every English word in the deck that shares a Hungarian meaning with
  /// [word]. "csak" is both *just* and *only*, so either answer is right no
  /// matter which card is on screen.
  List<String> englishSynonyms(VocabWord word) => {
        word.en,
        ...word.enAccepted,
        for (final hu in word.hu) ...?_byHu[hu.toLowerCase()],
      }.toList();

  static Future<VocabRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/vocabulary.json');
    final list = (jsonDecode(raw) as List)
        .map((e) => VocabWord.fromJson(e as Map<String, dynamic>))
        .toList();
    return VocabRepository(list);
  }

  VocabWord? byId(int id) => _byId[id];

  VocabWord? byEn(String en) => _byEn[en.toLowerCase()];

  List<VocabWord> byLevel(CefrLevel level) =>
      words.where((w) => w.level == level).toList();

  int get count => words.length;
}
