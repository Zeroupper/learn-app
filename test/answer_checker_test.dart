import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/services/answer_checker.dart';

void main() {
  Grade huCheck(String input, List<String> accepted) =>
      AnswerChecker.check(input, accepted, targetIsHu: true);
  Grade enCheck(String input, List<String> accepted) =>
      AnswerChecker.check(input, accepted, targetIsHu: false);

  test('case, whitespace and terminal punctuation are ignored', () {
    expect(huCheck('  VÍZ. ', ['víz']), Grade.correct);
    expect(huCheck('a  ház', ['ház']), Grade.correct);
  });

  test('accepts any answer from the accepted list', () {
    expect(huCheck('kocsi', ['autó', 'kocsi']), Grade.correct);
  });

  test('accent-only mismatch grades as almost', () {
    expect(huCheck('kor', ['kör']), Grade.almost);
    expect(huCheck('haz', ['ház']), Grade.almost);
  });

  test('a genuinely wrong answer is wrong', () {
    expect(huCheck('kutya', ['macska']), Grade.wrong);
    expect(huCheck('', ['víz']), Grade.wrong);
  });

  test('"to " prefix stripped for English verbs', () {
    expect(enCheck('to eat', ['eat']), Grade.correct);
    expect(enCheck('eat', ['to eat']), Grade.correct);
  });

  test('"a"/"az" prefix stripped for Hungarian', () {
    expect(huCheck('az alma', ['alma']), Grade.correct);
    expect(huCheck('a kutya', ['kutya']), Grade.correct);
  });

  test('decomposed accents (base + combining mark) match precomposed answer',
      () {
    final acute = String.fromCharCode(0x301); // combining acute
    final dblAcute = String.fromCharCode(0x30B); // combining double acute
    // "lát" typed as l + a + ´ + t
    expect(huCheck('la${acute}t', ['lát']), Grade.correct);
    // "nő" typed as n + o + ˝
    expect(huCheck('no$dblAcute', ['nő']), Grade.correct);
  });

  test('either Hungarian verb form is accepted (infinitive or 3rd person)', () {
    // stored as infinitive, user types 3rd person
    expect(huCheck('lát', ['látni']), Grade.correct);
    expect(huCheck('fut', ['futni', 'szaladni']), Grade.correct);
    // stored as 3rd person, user types infinitive
    expect(huCheck('látni', ['lát']), Grade.correct);
    // -ik verbs: dolgozik <-> dolgozni
    expect(huCheck('dolgozik', ['dolgozni']), Grade.correct);
    // a genuinely different verb is still wrong
    expect(huCheck('futni', ['úszni']), Grade.wrong);
  });

  test('case endings match with or without the leading hyphen', () {
    expect(huCheck('-ban', ['-ban']), Grade.correct);
    expect(huCheck('ban', ['-ban']), Grade.correct);
    expect(huCheck('-ban', ['ban']), Grade.correct);
  });

  test('any vowel-harmony variant of a case ending is accepted', () {
    // "in" is -ban/-ben; which one is right depends on a word that is not here.
    expect(huCheck('-ben', ['-ban']), Grade.correct);
    expect(huCheck('-ban', ['-ben']), Grade.correct);
    // "about" is -ról/-ről; "at" is -nál/-nél.
    expect(huCheck('rol', ['-ról']), Grade.correct);
    expect(huCheck('-ről', ['-ról']), Grade.correct);
    expect(huCheck('-nel', ['-nál']), Grade.correct);
    // "to" has a three-way harmony.
    expect(huCheck('-höz', ['-hoz']), Grade.correct);
    // Different suffixes stay different: -ban (in) is not -ra (onto).
    expect(huCheck('-ban', ['-ra']), Grade.wrong);
    expect(huCheck('-tol', ['-hoz']), Grade.wrong);
  });

  test('harmony never loosens plain words, whose accents carry meaning', () {
    // -kor is a suffix, but kör (circle) is a word: still only "almost".
    expect(huCheck('kor', ['kör']), Grade.almost);
    // ...whereas the suffix itself accepts the unaccented typing.
    expect(huCheck('kor', ['-kor']), Grade.correct);
    // én ("I") must not be swallowed by the -on/-en/-ön group.
    expect(huCheck('en', ['én']), Grade.almost);
  });
}
