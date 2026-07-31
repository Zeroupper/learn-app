import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/controllers/study_controller.dart';
import 'package:learn_app/data/vocab_repository.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';
import 'package:learn_app/services/answer_checker.dart';

void main() {
  VocabWord w(int id, String en, List<String> hu) => VocabWord(
        id: id,
        en: en,
        enAccepted: const [],
        hu: hu,
        level: CefrLevel.a1,
        pos: 'adverb',
      );

  // "csak" is the Hungarian for both of these.
  final just = w(1, 'just', ['csak', 'éppen']);
  final only = w(2, 'only', ['csak', 'csupán']);
  final vocab = VocabRepository([just, only, w(3, 'dog', ['kutya'])]);

  test('words sharing a Hungarian meaning are mutual synonyms', () {
    expect(vocab.englishSynonyms(just), containsAll(['just', 'only']));
    expect(vocab.englishSynonyms(only), containsAll(['just', 'only']));
    expect(vocab.englishSynonyms(w(3, 'dog', ['kutya'])), ['dog']);
  });

  test('either English word is correct on a shared Hungarian prompt', () {
    for (final card in [just, only]) {
      final p = StudyPrompt(card, Direction.huToEn,
          englishSynonyms: vocab.englishSynonyms(card));
      expect(p.promptText, 'csak');
      for (final answer in ['just', 'only']) {
        expect(AnswerChecker.check(answer, p.accepted, targetIsHu: false),
            Grade.correct,
            reason: '"$answer" should be accepted for ${card.en}');
      }
      expect(AnswerChecker.check('dog', p.accepted, targetIsHu: false),
          Grade.wrong);
    }
  });

  test('without the deck index a prompt falls back to its own English', () {
    final p = StudyPrompt(just, Direction.huToEn);
    expect(p.accepted, ['just']);
  });
}
