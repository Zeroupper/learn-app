import 'package:flutter/material.dart';

import '../config.dart';
import 'listening_screen.dart';
import 'reading_screen.dart';
import 'sentence_practice_screen.dart';
import 'speaking_screen.dart';

class AiHubScreen extends StatelessWidget {
  const AiHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI gyakorlás')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Free, on-device — no API key needed.
          _tile(
            context,
            icon: Icons.mic,
            title: 'Beszéd',
            subtitle: 'Mondd ki a mondatot, a telefon ellenőrzi a kiejtést.',
            builder: (_) => const SpeakingScreen(),
          ),
          const Divider(height: 24),
          if (!hasApiKey)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'A többi AI funkcióhoz add meg az OpenRouter API kulcsot '
                'fordításkor: --dart-define=OPENROUTER_API_KEY=…',
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            _tile(
              context,
              icon: Icons.edit_note,
              title: 'Mondatgyakorlás',
              subtitle: 'Írj angol mondatokat, az AI kijavítja és értékeli.',
              builder: (_) => const SentencePracticeScreen(),
            ),
            _tile(
              context,
              icon: Icons.menu_book,
              title: 'Olvasás',
              subtitle: 'Kérj egy szintednek megfelelő szöveget kérdésekkel.',
              builder: (_) => const ReadingScreen(),
            ),
            _tile(
              context,
              icon: Icons.headphones,
              title: 'Hallás utáni értés',
              subtitle: 'Csak hallgatod a szöveget, majd kérdésekre válaszolsz.',
              builder: (_) => const ListeningScreen(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required WidgetBuilder builder}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: builder)),
      ),
    );
  }
}
