import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/dashboard_controller.dart';
import '../screens/settings_screen.dart';

/// Common scaffold for the top-level screens: title on the left, streak and
/// learned-word counters on the right, plus the settings gear on the home tab.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.child,
    this.showSettings = false,
  });

  final String title;
  final Widget child;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsStore>().stats;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          _Counter(
            icon: Icons.local_fire_department,
            // Grey flame until the streak is actually alive.
            color: (stats?.streak ?? 0) > 0 ? Colors.deepOrange : Colors.grey,
            value: stats?.streak,
            label: 'Sorozat (nap)',
          ),
          _Counter(
            icon: Icons.menu_book,
            color: Colors.blue,
            value: stats?.learnedWords,
            label: 'Megtanult szavak',
          ),
          _Counter(
            icon: Icons.favorite,
            color: (stats?.hearts ?? 0) > 0 ? Colors.red : Colors.grey,
            value: stats?.hearts,
            label: stats == null || stats.wordsToNextHeart == 0
                ? 'Életek — egy kihagyott nap egy életbe kerül'
                : 'Életek — még ${stats.wordsToNextHeart} szó a következőig',
          ),
          if (showSettings)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Beállítások',
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen())),
            )
          else
            const SizedBox(width: 8),
        ],
      ),
      body: child,
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final int? value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            // ponytail: em dash while the first load is in flight — a spinner
            // in the app bar is more distracting than a placeholder.
            Text(
              value?.toString() ?? '—',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
