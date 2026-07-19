class SentenceError {
  final String original;
  final String corrected;
  final String explanationHu;
  const SentenceError(this.original, this.corrected, this.explanationHu);

  factory SentenceError.fromJson(Map<String, dynamic> j) => SentenceError(
        j['original'] as String? ?? '',
        j['corrected'] as String? ?? '',
        j['explanation_hu'] as String? ?? '',
      );
}

class SentenceEvaluation {
  final int score; // 0-100
  final bool isCorrect;
  final String corrected;
  final List<SentenceError> errors;
  final String explanationHu;

  const SentenceEvaluation({
    required this.score,
    required this.isCorrect,
    required this.corrected,
    required this.errors,
    required this.explanationHu,
  });

  factory SentenceEvaluation.fromJson(Map<String, dynamic> j) =>
      SentenceEvaluation(
        score: (j['score'] as num?)?.toInt() ?? 0,
        isCorrect: j['is_correct'] as bool? ?? false,
        corrected: j['corrected'] as String? ?? '',
        errors: (j['errors'] as List? ?? [])
            .map((e) => SentenceError.fromJson(e as Map<String, dynamic>))
            .toList(),
        explanationHu: j['explanation_hu'] as String? ?? '',
      );

  /// JSON schema for OpenRouter structured output.
  static const schema = {
    'type': 'object',
    'additionalProperties': false,
    'required': ['score', 'is_correct', 'corrected', 'errors', 'explanation_hu'],
    'properties': {
      'score': {'type': 'integer'},
      'is_correct': {'type': 'boolean'},
      'corrected': {'type': 'string'},
      'errors': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': ['original', 'corrected', 'explanation_hu'],
          'properties': {
            'original': {'type': 'string'},
            'corrected': {'type': 'string'},
            'explanation_hu': {'type': 'string'},
          },
        },
      },
      'explanation_hu': {'type': 'string'},
    },
  };
}
