import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'text_scale.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/study_setup_screen.dart';
import 'screens/grammar_list_screen.dart';
import 'screens/ai_hub_screen.dart';

class LearnApp extends StatelessWidget {
  const LearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeChoice>();
    return MaterialApp(
      title: 'Learn English',
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: ThemeMode.system,
      // Apply the user's chosen font scale (Settings) app-wide, live.
      builder: (context, child) {
        final scale = context.watch<TextScale>().value;
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: scale,
          maxScaleFactor: scale,
          child: child!,
        );
      },
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    StudySetupScreen(),
    GrammarListScreen(),
    AiHubScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Kezdőlap'),
          NavigationDestination(icon: Icon(Icons.style_outlined), selectedIcon: Icon(Icons.style), label: 'Kártyák'),
          NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Nyelvtan'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'AI'),
        ],
      ),
    );
  }
}
