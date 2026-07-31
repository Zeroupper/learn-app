import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/study_controller.dart';
import '../data/settings_repository.dart';
import '../data/srs_repository.dart';
import '../data/vocab_repository.dart';
import '../models/review_state.dart';
import '../models/vocab_word.dart';
import '../services/session_builder.dart';
import 'study_screen.dart';
import '../widgets/app_shell.dart';

enum _DirChoice { enToHu, huToEn, mixed }

class StudySetupScreen extends StatefulWidget {
  const StudySetupScreen({super.key});

  @override
  State<StudySetupScreen> createState() => _StudySetupScreenState();
}

class _StudySetupScreenState extends State<StudySetupScreen> {
  _DirChoice _dir = _DirChoice.enToHu;
  final Set<CefrLevel> _levels = {CefrLevel.a1};

  List<Direction> get _directions => switch (_dir) {
        _DirChoice.enToHu => [Direction.enToHu],
        _DirChoice.huToEn => [Direction.huToEn],
        _DirChoice.mixed => [Direction.enToHu, Direction.huToEn],
      };

  Future<List<SessionCard>> _buildQueue() async {
    final vocab = context.read<VocabRepository>();
    final srs = context.read<SrsRepository>();
    final settings = context.read<SettingsRepository>();
    final now = DateTime.now();
    final dirs = _directions;

    final words =
        vocab.words.where((w) => _levels.contains(w.level)).toList();
    final levelIds = words.map((w) => w.id).toSet();
    final due = (await srs.dueCards(dirs, now))
        .where((s) => levelIds.contains(s.wordId))
        .toList();
    final existing = (await srs.allStates())
        .map((s) => '${s.wordId}:${s.direction.code}')
        .toSet();
    final size = await settings.sessionSize();

    return SessionBuilder.build(
      words: words,
      directions: dirs,
      dueStates: due,
      existingKeys: existing,
      sessionSize: size,
    );
  }

  Future<void> _start() async {
    final queue = await _buildQueue();
    if (!mounted) return;
    if (queue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Nincs gyakorolható kártya ehhez a beállításhoz.')));
      return;
    }
    final vocab = context.read<VocabRepository>();
    final srs = context.read<SrsRepository>();
    final controller = StudyController.withRepo(
      queue: queue,
      lookup: (id) => vocab.byId(id)!,
      synonyms: vocab.englishSynonyms,
      srs: srs,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StudyScreen(controller: controller)),
    );
    setState(() {}); // refresh counts after a session
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Kártyák',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Irány', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<_DirChoice>(
              segments: const [
                ButtonSegment(value: _DirChoice.enToHu, label: Text('EN→HU')),
                ButtonSegment(value: _DirChoice.huToEn, label: Text('HU→EN')),
                ButtonSegment(value: _DirChoice.mixed, label: Text('Vegyes')),
              ],
              selected: {_dir},
              onSelectionChanged: (s) => setState(() => _dir = s.first),
            ),
            const SizedBox(height: 24),
            const Text('Szint', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final level in CefrLevel.values)
                  FilterChip(
                    label: Text(level.label),
                    selected: _levels.contains(level),
                    onSelected: (on) => setState(() {
                      if (on) {
                        _levels.add(level);
                      } else if (_levels.length > 1) {
                        _levels.remove(level);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _CountsRow(buildQueue: _buildQueue),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _start,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Kezdés'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows how many cards the current selection would produce.
class _CountsRow extends StatelessWidget {
  final Future<List<SessionCard>> Function() buildQueue;
  const _CountsRow({required this.buildQueue});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SessionCard>>(
      future: buildQueue(),
      builder: (context, snap) {
        final n = snap.data?.length ?? 0;
        return Text('Kártyák ebben a körben: $n',
            style: Theme.of(context).textTheme.bodyLarge);
      },
    );
  }
}
