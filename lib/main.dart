import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app.dart';
import 'config.dart';
import 'data/app_database.dart';
import 'data/grammar_repository.dart';
import 'data/settings_repository.dart';
import 'data/srs_repository.dart';
import 'data/vocab_repository.dart';
import 'services/ai_service.dart';
import 'services/tts_service.dart';
import 'text_scale.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await AppDatabase.open();
  final vocab = await VocabRepository.load();
  final settings = SettingsRepository(db);
  final textScale = TextScale(settings, await settings.textScale());

  runApp(
    MultiProvider(
      providers: [
        Provider<VocabRepository>.value(value: vocab),
        Provider<SrsRepository>.value(value: SrsRepository(db)),
        Provider<SettingsRepository>.value(value: settings),
        ChangeNotifierProvider<TextScale>.value(value: textScale),
        Provider<GrammarRepository>(create: (_) => GrammarRepository()),
        Provider<TtsService>(
          create: (_) => TtsService(),
          dispose: (_, t) => t.stop(),
        ),
        Provider<AiService>(
          create: (ctx) => AiService(
            client: http.Client(),
            getApiKey: () async => openRouterApiKey,
            getModel: ctx.read<SettingsRepository>().model,
          ),
        ),
      ],
      child: const LearnApp(),
    ),
  );
}
