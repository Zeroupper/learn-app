import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/grammar_repository.dart';
import '../data/settings_repository.dart';
import '../models/grammar_lesson.dart';
import '../models/vocab_word.dart';
import 'grammar_lesson_screen.dart';
import '../widgets/app_shell.dart';

class GrammarListScreen extends StatefulWidget {
  const GrammarListScreen({super.key});

  @override
  State<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends State<GrammarListScreen> {
  late Future<List<GrammarLessonMeta>> _index;

  @override
  void initState() {
    super.initState();
    _index = context.read<GrammarRepository>().loadIndex();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsRepository>();
    return AppShell(
      title: 'Nyelvtan',
      child: FutureBuilder<List<GrammarLessonMeta>>(
        future: _index,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lessons = snap.data!;
          return ListView(
            children: [
              for (final level in CefrLevel.values)
                ..._levelSection(context, settings, level,
                    lessons.where((l) => l.level == level).toList()),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _levelSection(BuildContext context, SettingsRepository settings,
      CefrLevel level, List<GrammarLessonMeta> lessons) {
    if (lessons.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(level.label,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary)),
      ),
      for (final l in lessons)
        FutureBuilder<bool>(
          future: settings.isGrammarDone(l.id),
          builder: (context, s) => ListTile(
            leading: Icon(s.data == true
                ? Icons.check_circle
                : Icons.circle_outlined),
            title: Text(l.titleHu),
            subtitle: Text(l.subtitleHu),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GrammarLessonScreen(meta: l)));
              setState(() {}); // refresh completion ticks
            },
          ),
        ),
    ];
  }
}
