import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/grammar_lesson.dart';

/// Loads bundled grammar lessons from assets/data/grammar/.
class GrammarRepository {
  static const _dir = 'assets/data/grammar';

  Future<List<GrammarLessonMeta>> loadIndex() async {
    final raw = await rootBundle.loadString('$_dir/index.json');
    return (jsonDecode(raw) as List)
        .map((e) => GrammarLessonMeta.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GrammarLesson> loadLesson(String file) async {
    final raw = await rootBundle.loadString('$_dir/$file');
    return GrammarLesson.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
