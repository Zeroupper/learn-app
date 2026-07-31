import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../controllers/dashboard_controller.dart';
import '../data/settings_repository.dart';
import '../services/ai_service.dart';
import '../text_scale.dart';
import '../theme.dart';
import '../widgets/lightning_route.dart';
import 'about_screen.dart';
import 'streak_celebration_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _model = TextEditingController();
  final _cap = TextEditingController();
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = context.read<SettingsRepository>();
    _model.text = await settings.model();
    _cap.text = (await settings.sessionSize()).toString();
    setState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    _cap.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _test() async {
    setState(() => _testing = true);
    try {
      await context.read<AiService>().evaluateSentence(
          topic: 'test', level: 'a1', sentence: 'This is a test.');
      if (mounted) _snack('Sikeres teszt! A kulcs és a modell működik.');
    } on AiException catch (e) {
      if (mounted) _snack(e.messageHu);
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _saveModel() async {
    final m = _model.text.trim();
    if (m.isNotEmpty) {
      await context.read<SettingsRepository>().set(SettingsRepository.keyModel, m);
    }
  }

  Future<void> _saveCap() async {
    final n = int.tryParse(_cap.text.trim());
    if (n != null && n >= 1) {
      await context
          .read<SettingsRepository>()
          .set(SettingsRepository.keySessionSize, '$n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beállítások')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('OpenRouter API kulcs',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(hasApiKey ? Icons.check_circle : Icons.cancel,
                  color: hasApiKey ? Colors.green : Colors.grey,
                  size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hasApiKey
                      ? 'Beállítva (fordításkori --dart-define).'
                      : 'Nincs megadva. Add meg fordításkor: --dart-define=OPENROUTER_API_KEY=…',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: hasApiKey && !_testing ? _test : null,
            child: _testing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Kapcsolat tesztelése'),
          ),
          const Divider(height: 32),
          const _ThemeSetting(),
          const Divider(height: 32),
          const _FontScaleSetting(),
          const Divider(height: 32),
          Text('AI modell', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _model,
            onEditingComplete: _saveModel,
            onTapOutside: (_) => _saveModel(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              helperText: 'pl. anthropic/claude-haiku-4.5',
            ),
          ),
          const Divider(height: 32),
          Text('Kártyák egy körben',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _cap,
            keyboardType: TextInputType.number,
            onEditingComplete: _saveCap,
            onTapOutside: (_) => _saveCap(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              helperText: 'Egy gyakorlás ennyi kártyából áll (esedékes + új)',
            ),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.local_fire_department,
                color: Colors.deepOrange),
            title: const Text('Sorozat képernyő megtekintése'),
            subtitle: const Text('Az ünneplő képernyő napi korlát nélkül'),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              // Uses the real streak, so it previews exactly what the day's
              // first finished exercise would show.
              final streak = context.read<StatsStore>().stats?.streak ?? 0;
              Navigator.of(context).push(lightningStrikeRoute(
                StreakCelebrationScreen(streak: streak == 0 ? 1 : streak),
              ));
            },
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Névjegy és licencek'),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: EdgeInsets.zero,
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
        ],
      ),
    );
  }
}

/// Theme picker; the app repaints under it the moment a tile is tapped.
class _ThemeSetting extends StatelessWidget {
  const _ThemeSetting();

  @override
  Widget build(BuildContext context) {
    final choice = context.watch<ThemeChoice>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Téma', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        RadioGroup<AppTheme>(
          groupValue: choice.value,
          onChanged: (t) => choice.set(t!),
          child: Column(
            children: [
              for (final theme in AppTheme.values)
                RadioListTile<AppTheme>(
                  value: theme,
                  contentPadding: EdgeInsets.zero,
                  title: Text(theme.label),
                  subtitle: Text(theme.blurb),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Live font-size slider; the whole app (including this preview) rescales.
class _FontScaleSetting extends StatelessWidget {
  const _FontScaleSetting();

  @override
  Widget build(BuildContext context) {
    final textScale = context.watch<TextScale>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Betűméret', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        const Text('Előnézet: ekkora lesz a szöveg az alkalmazásban.'),
        Row(
          children: [
            const Text('A', style: TextStyle(fontSize: 12)),
            Expanded(
              child: Slider(
                value: textScale.value.clamp(TextScale.min, TextScale.max),
                min: TextScale.min,
                max: TextScale.max,
                divisions: ((TextScale.max - TextScale.min) / 0.05).round(),
                label: '${(textScale.value * 100).round()}%',
                onChanged: (v) => textScale.set(v),
              ),
            ),
            const Text('A', style: TextStyle(fontSize: 22)),
          ],
        ),
      ],
    );
  }
}
