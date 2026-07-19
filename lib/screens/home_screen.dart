import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/dashboard_controller.dart';
import '../data/srs_repository.dart';
import '../data/vocab_repository.dart';
import '../widgets/level_progress_card.dart';
import 'study_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardStats> _stats;
  late final SrsRepository _srs;

  @override
  void initState() {
    super.initState();
    _srs = context.read<SrsRepository>();
    _srs.revision.addListener(_onReviewsChanged);
    _stats = _load();
  }

  @override
  void dispose() {
    _srs.revision.removeListener(_onReviewsChanged);
    super.dispose();
  }

  void _onReviewsChanged() {
    if (mounted) setState(() => _stats = _load());
  }

  Future<DashboardStats> _load() => DashboardController.load(
        context.read<VocabRepository>(),
        _srs,
      );

  Future<void> _refresh() async {
    setState(() => _stats = _load());
    await _stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kezdőlap')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<DashboardStats>(
          future: _stats,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final s = snap.data!;
            return ListView(
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
                for (final level in s.levels)
                  LevelProgressCard(stat: level),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const StudySetupScreen()));
                    _refresh();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Gyakorlás'),
                ),
              ],
            );
          },
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
