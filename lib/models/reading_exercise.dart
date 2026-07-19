class ReadingQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  const ReadingQuestion(this.question, this.options, this.correctIndex);

  factory ReadingQuestion.fromJson(Map<String, dynamic> j) => ReadingQuestion(
        j['question'] as String? ?? '',
        (j['options'] as List? ?? []).cast<String>(),
        (j['correct_index'] as num?)?.toInt() ?? 0,
      );
}

class GlossaryEntry {
  final String en;
  final String hu;
  const GlossaryEntry(this.en, this.hu);

  factory GlossaryEntry.fromJson(Map<String, dynamic> j) =>
      GlossaryEntry(j['en'] as String? ?? '', j['hu'] as String? ?? '');
}

class ReadingExercise {
  final String title;
  final String text;
  final List<ReadingQuestion> questions;
  final List<GlossaryEntry> glossary;

  const ReadingExercise({
    required this.title,
    required this.text,
    required this.questions,
    required this.glossary,
  });

  factory ReadingExercise.fromJson(Map<String, dynamic> j) => ReadingExercise(
        title: j['title'] as String? ?? '',
        text: j['text'] as String? ?? '',
        questions: (j['questions'] as List? ?? [])
            .map((e) => ReadingQuestion.fromJson(e as Map<String, dynamic>))
            .toList(),
        glossary: (j['glossary'] as List? ?? [])
            .map((e) => GlossaryEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static const schema = {
    'type': 'object',
    'additionalProperties': false,
    'required': ['title', 'text', 'questions', 'glossary'],
    'properties': {
      'title': {'type': 'string'},
      'text': {'type': 'string'},
      'questions': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': ['question', 'options', 'correct_index'],
          'properties': {
            'question': {'type': 'string'},
            'options': {'type': 'array', 'items': {'type': 'string'}},
            'correct_index': {'type': 'integer'},
          },
        },
      },
      'glossary': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': ['en', 'hu'],
          'properties': {
            'en': {'type': 'string'},
            'hu': {'type': 'string'},
          },
        },
      },
    },
  };
}
