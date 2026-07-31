import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/app_shell.dart';
import '../widgets/level_progress_card.dart';
import 'study_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StatsStore>();
    final s = store.stats;
    return AppShell(
      title: 'Kezdőlap',
      showSettings: true,
      child: RefreshIndicator(
        onRefresh: store.refresh,
        child: s == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _overall(context, s),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _statTile(context, 'Ma', '${s.reviewsToday}', 'ismétlés'),
                      const SizedBox(width: 12),
                      _statTile(context, 'Sorozat', '${s.streak}', 'nap'),
                      const SizedBox(width: 12),
                      _statTile(context, 'Esedékes', '${s.dueCount}', 'kártya'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final level in s.levels) LevelProgressCard(stat: level),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const StudySetupScreen())),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Gyakorlás'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _overall(BuildContext context, DashboardStats s) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: s.overallProgress,
                    strokeWidth: 8,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  Text('${(s.overallProgress * 100).round()}%',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${s.learnedWords} / ${s.totalWords} szó megtanulva',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Ebből ${s.masteredWords} véglegesen rögzült',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statTile(
      BuildContext context, String label, String value, String unit) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(unit, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
