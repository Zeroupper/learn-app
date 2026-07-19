import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/vocab_word.dart';

/// Loads the bundled vocabulary asset into memory once at startup.
class VocabRepository {
  final List<VocabWord> words;
  final Map<int, VocabWord> _byId;
  final Map<String, VocabWord> _byEn;

  VocabRepository(this.words)
      : _byId = {for (final w in words) w.id: w},
        _byEn = {for (final w in words) w.en.toLowerCase(): w};

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
