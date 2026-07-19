import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Névjegy és licencek')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Angol tanulás magyaroknak',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
              'Személyes nyelvtanuló alkalmazás A1–B1 szinten: szókártyák '
              'ismétléssel, nyelvtani leckék és AI-gyakorlás.'),
          const Divider(height: 32),
          Text('Adatforrások', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const _Attribution(
            title: 'CEFR-J Wordlist',
            body: 'Szólista és CEFR szintek. © CEFR-J, CC BY-SA 4.0.',
          ),
          const _Attribution(
            title: 'Wiktionary',
            body:
                'Magyar fordítások egy Wiktionary-alapú szótárból. Szöveg: CC BY-SA 4.0, '
                'Wikimedia Foundation és közreműködők.',
          ),
          const _Attribution(
            title: 'wordfreq',
            body: 'Gyakorisági rangsor a szóválogatáshoz. CC BY-SA 4.0.',
          ),
          const _Attribution(
            title: 'Google TTS (flutter_tts)',
            body: 'Szövegfelolvasás az eszköz beszédmotorjával.',
          ),
          const _Attribution(
            title: 'OpenRouter',
            body: 'AI mondatértékelés és szöveggenerálás (saját API kulccsal).',
          ),
        ],
      ),
    );
  }
}

class _Attribution extends StatelessWidget {
  final String title;
  final String body;
  const _Attribution({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(body, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
