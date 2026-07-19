/// Grade for a typed answer.
enum Grade { correct, almost, wrong }

/// Pure answer checking: normalized match against a list of accepted answers,
/// with accent-only mismatches graded as [Grade.almost] (Hungarian accents are
/// meaningful: kor / kór / kör differ).
class AnswerChecker {
  // Combining marks: acute U+0301, diaeresis U+0308, double acute U+030B.
  static const _acute = 0x0301;
  static const _diaeresis = 0x0308;
  static const _dblAcute = 0x030B;

  /// Compose accented vowels typed as base letter + combining mark
  /// (e.g. 'a' + U+0301) into the precomposed form the asset stores, so an
  /// exact match works regardless of the keyboard's Unicode output.
  static String _composeAccents(String s) {
    const map = {
      'a301': 'á', 'e301': 'é', 'i301': 'í', 'o301': 'ó', 'u301': 'ú',
      'o308': 'ö', 'u308': 'ü', 'o30b': 'ő', 'u30b': 'ű',
    };
    final runes = s.runes.toList();
    final out = StringBuffer();
    for (var i = 0; i < runes.length; i++) {
      if (i + 1 < runes.length) {
        final mark = runes[i + 1];
        if (mark == _acute || mark == _diaeresis || mark == _dblAcute) {
          final key =
              '${String.fromCharCode(runes[i])}${mark.toRadixString(16)}';
          final composed = map[key];
          if (composed != null) {
            out.write(composed);
            i++; // consume the combining mark
            continue;
          }
        }
      }
      out.writeCharCode(runes[i]);
    }
    return out.toString();
  }

  /// Lowercase, compose accents, trim, collapse whitespace, strip terminal
  /// punctuation, and drop an optional leading "to " (English verbs) or
  /// "a "/"az " (Hungarian).
  static String normalize(String input, {required bool targetIsHu}) {
    var s = _composeAccents(input.toLowerCase()).trim();
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    s = s.replaceAll(RegExp(r'[.!?,;:]+$'), '').trim();
    if (targetIsHu) {
      if (s.startsWith('az ')) {
        s = s.substring(3);
      } else if (s.startsWith('a ')) {
        s = s.substring(2);
      }
    } else if (s.startsWith('to ')) {
      s = s.substring(3);
    }
    return s.trim();
  }

  static const _accentMap = {
    'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ö': 'o',
    'ő': 'o', 'ú': 'u', 'ü': 'u', 'ű': 'u',
  };

  static String _fold(String s) {
    final b = StringBuffer();
    for (final ch in s.split('')) {
      b.write(_accentMap[ch] ?? ch);
    }
    // Also drop any leftover combining diacritics (U+0300–U+036F).
    return b.toString().replaceAll(RegExp('[̀-ͯ]'), '');
  }

  /// [accepted] are the correct answers in the target language.
  static Grade check(String input, List<String> accepted,
      {required bool targetIsHu}) {
    final normInput = normalize(input, targetIsHu: targetIsHu);
    if (normInput.isEmpty) return Grade.wrong;
    final normAccepted =
        accepted.map((a) => normalize(a, targetIsHu: targetIsHu)).toList();
    if (normAccepted.contains(normInput)) return Grade.correct;
    // Accept either Hungarian verb form: infinitive (látni) or 3rd person (lát).
    if (targetIsHu) {
      final stemInput = _verbStem(normInput);
      if (normAccepted.any((a) => _verbStem(a) == stemInput)) {
        return Grade.correct;
      }
    }
    final foldInput = _fold(normInput);
    if (normAccepted.any((a) => _fold(a) == foldInput)) return Grade.almost;
    return Grade.wrong;
  }

  /// Reduces a Hungarian verb form to its stem so the infinitive (-ni) and the
  /// 3rd-person (-ik) forms compare equal: látni/lát, dolgozni/dolgozik.
  // ponytail: heuristic suffix strip, not a full morphology engine; good enough
  // for accepting both dictionary forms of a verb.
  static String _verbStem(String s) {
    if (s.length > 3 && s.endsWith('ni')) return s.substring(0, s.length - 2);
    if (s.length > 3 && s.endsWith('ik')) return s.substring(0, s.length - 2);
    return s;
  }
}
