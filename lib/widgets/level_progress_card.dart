import 'package:flutter/material.dart';

import '../controllers/dashboard_controller.dart';

class LevelProgressCard extends StatelessWidget {
  final LevelStat stat;
  const LevelProgressCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(stat.level.label,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${stat.learned} / ${stat.total} megtanulva'),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: stat.progress,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 4),
            Text('${stat.mastered} véglegesen rögzült',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
