import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:learn_app/services/ai_service.dart';

void main() {
  String evalBody(Map<String, dynamic> content) => jsonEncode({
        'choices': [
          {
            'finish_reason': 'stop',
            'message': {'content': jsonEncode(content)}
          }
        ]
      });

  AiService service(MockClient client) => AiService(
        client: client,
        getApiKey: () async => 'testkey',
        getModel: () async => 'anthropic/claude-haiku-4.5',
      );

  test('sends the correct request shape and parses the evaluation', () async {
    late http.Request seen;
    final client = MockClient((req) async {
      seen = req;
      return http.Response(
        evalBody({
          'score': 80,
          'is_correct': true,
          'corrected': 'I have a dog.',
          'errors': [],
          'explanation_hu': 'Helyes mondat.',
        }),
        200,
      );
    });

    final result = await service(client).evaluateSentence(
        topic: 'animals', level: 'a1', sentence: 'I have a dog.');

    expect(seen.url.toString(),
        'https://openrouter.ai/api/v1/chat/completions');
    expect(seen.headers['Authorization'], 'Bearer testkey');
    final body = jsonDecode(seen.body) as Map<String, dynamic>;
    expect(body['model'], 'anthropic/claude-haiku-4.5');
    expect(body['response_format']['type'], 'json_schema');
    expect(result.score, 80);
    expect(result.isCorrect, true);
  });

  test('strips a code fence around the JSON content', () async {
    final client = MockClient((req) async => http.Response(
          jsonEncode({
            'choices': [
              {
                'finish_reason': 'stop',
                'message': {
                  'content':
                      '```json\n{"score":50,"is_correct":false,"corrected":"x","errors":[],"explanation_hu":"y"}\n```'
                }
              }
            ]
          }),
          200,
        ));
    final r = await service(client)
        .evaluateSentence(topic: 't', level: 'a1', sentence: 's');
    expect(r.score, 50);
  });

  test('401 -> invalid key message', () async {
    final client = MockClient((req) async => http.Response('no', 401));
    expect(
      () => service(client)
          .evaluateSentence(topic: 't', level: 'a1', sentence: 's'),
      throwsA(isA<AiException>()
          .having((e) => e.messageHu, 'msg', contains('API kulcs'))),
    );
  });

  test('402 -> out of credit message', () async {
    final client = MockClient((req) async => http.Response('no', 402));
    expect(
      () => service(client)
          .evaluateSentence(topic: 't', level: 'a1', sentence: 's'),
      throwsA(isA<AiException>()
          .having((e) => e.messageHu, 'msg', contains('kredit'))),
    );
  });

  test('malformed JSON content -> friendly parse error', () async {
    final client = MockClient((req) async => http.Response(
          jsonEncode({
            'choices': [
              {
                'finish_reason': 'stop',
                'message': {'content': 'not json at all'}
              }
            ]
          }),
          200,
        ));
    expect(
      () => service(client)
          .evaluateSentence(topic: 't', level: 'a1', sentence: 's'),
      throwsA(isA<AiException>()
          .having((e) => e.messageHu, 'msg', contains('feldolgozni'))),
    );
  });

  test('missing API key -> settings prompt, no request made', () async {
    var called = false;
    final client = MockClient((req) async {
      called = true;
      return http.Response('', 200);
    });
    final svc = AiService(
      client: client,
      getApiKey: () async => null,
      getModel: () async => 'm',
    );
    expect(
      () => svc.evaluateSentence(topic: 't', level: 'a1', sentence: 's'),
      throwsA(isA<AiException>()
          .having((e) => e.messageHu, 'msg', contains('Beállításokban'))),
    );
    expect(called, false);
  });

  test('429 then 200 -> retries and succeeds', () async {
    var n = 0;
    final client = MockClient((req) async {
      n++;
      if (n == 1) {
        return http.Response('slow down', 429, headers: {'retry-after': '1'});
      }
      return http.Response(
        evalBody({
          'score': 70,
          'is_correct': true,
          'corrected': 'ok',
          'errors': [],
          'explanation_hu': 'jó',
        }),
        200,
      );
    });
    final r = await service(client)
        .evaluateSentence(topic: 't', level: 'a1', sentence: 's');
    expect(n, 2);
    expect(r.score, 70);
  });

  test('finish_reason length -> retry hint', () async {
    final client = MockClient((req) async => http.Response(
          jsonEncode({
            'choices': [
              {'finish_reason': 'length', 'message': {'content': '{}'}}
            ]
          }),
          200,
        ));
    expect(
      () => service(client)
          .evaluateSentence(topic: 't', level: 'a1', sentence: 's'),
      throwsA(isA<AiException>()
          .having((e) => e.messageHu, 'msg', contains('túl hosszú'))),
    );
  });
}
