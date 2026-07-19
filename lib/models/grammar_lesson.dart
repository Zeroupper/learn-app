import 'vocab_word.dart';

class GrammarExample {
  final String en;
  final String hu;
  const GrammarExample(this.en, this.hu);

  factory GrammarExample.fromJson(Map<String, dynamic> j) =>
      GrammarExample(j['en'] as String, j['hu'] as String);
}

class GrammarSection {
  final String headingHu;
  final String bodyHu;
  final List<GrammarExample> examples;
  const GrammarSection(this.headingHu, this.bodyHu, this.examples);

  factory GrammarSection.fromJson(Map<String, dynamic> j) => GrammarSection(
        j['heading_hu'] as String,
        j['body_hu'] as String,
        (j['examples'] as List? ?? [])
            .map((e) => GrammarExample.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class GrammarExercise {
  final String promptHu;
  final List<String> options;
  final int correctIndex;
  final String explanationHu;
  const GrammarExercise(
      this.promptHu, this.options, this.correctIndex, this.explanationHu);

  factory GrammarExercise.fromJson(Map<String, dynamic> j) => GrammarExercise(
        j['prompt_hu'] as String,
        (j['options'] as List).cast<String>(),
        j['correct_index'] as int,
        j['explanation_hu'] as String,
      );
}

/// Lightweight metadata from index.json (list screen, no full load).
class GrammarLessonMeta {
  final String id;
  final String file;
  final String titleHu;
  final String subtitleHu;
  final CefrLevel level;
  const GrammarLessonMeta(
      this.id, this.file, this.titleHu, this.subtitleHu, this.level);

  factory GrammarLessonMeta.fromJson(Map<String, dynamic> j) =>
      GrammarLessonMeta(
        j['id'] as String,
        j['file'] as String,
        j['title_hu'] as String,
        j['subtitle_hu'] as String,
        CefrLevel.fromString(j['level'] as String),
      );
}

class GrammarLesson {
  final String id;
  final String titleHu;
  final String subtitleHu;
  final CefrLevel level;
  final List<GrammarSection> sections;
  final List<GrammarExercise> exercises;
  const GrammarLesson(this.id, this.titleHu, this.subtitleHu, this.level,
      this.sections, this.exercises);

  factory GrammarLesson.fromJson(Map<String, dynamic> j) => GrammarLesson(
        j['id'] as String,
        j['title_hu'] as String,
        j['subtitle_hu'] as String,
        CefrLevel.fromString(j['level'] as String),
        (j['sections'] as List)
            .map((e) => GrammarSection.fromJson(e as Map<String, dynamic>))
            .toList(),
        (j['exercises'] as List)
            .map((e) => GrammarExercise.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
