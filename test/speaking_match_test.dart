import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/screens/speaking_screen.dart';

void main() {
  const target = "The apartment is smaller than we expected, yet it's in a "
      'perfect location for our needs.';

  test('exact read, punctuation and case ignored', () {
    expect(speechMatches(target.toUpperCase(), target), isTrue);
  });

  test('one mangled word still passes a long sentence', () {
    expect(speechMatches(target.replaceAll(' smaller ', ' smallish '), target),
        isTrue);
  });

  test('two mangled words fail', () {
    final heard =
        target.replaceAll(' smaller ', ' smallish ').replaceAll(' perfect ', ' prefect ');
    expect(speechMatches(heard, target), isFalse);
  });

  test('a half-spoken sentence fails', () {
    expect(speechMatches('The apartment is', target), isFalse);
  });

  test('short sentences get no slack — one word is too much of the answer', () {
    expect(allowedMissesFor('Are you cold?'), 0);
    expect(allowedMissesFor(target), 1);
    expect(speechMatches('I am', 'I am tired'), isFalse);
  });

  test('filler the recogniser invents is ignored', () {
    expect(speechMatches('um I am tired', 'I am tired'), isTrue);
  });

  group('matchedWords — drives both the verdict and the word colouring', () {
    test('marks exactly the words that were said', () {
      expect(matchedWords('I am tired', 'I am tired'), [true, true, true]);
      expect(matchedWords('I am', 'I am tired'), [true, true, false]);
      expect(matchedWords('', 'I am tired'), [false, false, false]);
    });

    test('a mangled word costs only itself, not the rest of the sentence', () {
      expect(matchedWords('I em tired', 'I am tired'), [true, false, true]);
    });

    test('one entry per target word, whatever the recogniser returns', () {
      expect(matchedWords('um so I am really tired', 'I am tired').length, 3);
    });
  });

  test('empty input fails', () {
    expect(speechMatches('', target), isFalse);
  });
}
