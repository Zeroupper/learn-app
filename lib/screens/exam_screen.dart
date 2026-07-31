import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/settings_repository.dart';
import '../models/exam.dart';
import '../services/ai_service.dart';
import '../services/tts_service.dart';

enum _Phase { setup, generating, filling, grading, result }

/// The levels that can be sat, in order.
const examLevels = ['a1', 'a2', 'b1'];

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  _Phase _phase = _Phase.setup;
  String _level = 'a1';
  String? _error;

  Exam? _exam;
  ExamResult? _result;

  /// Question id -> the student's answer, as the text of the chosen option or
  /// their writing. Storing text (not an index) is what the marker receives.
  final _answers = <String, String>{};
  final _writing = <String, TextEditingController>{};

  /// Which section is on screen while sitting the exam — one section per page.
  int _step = 0;

  /// Past papers, newest first.
  var _history = <ExamAttempt>[];

  /// Levels with at least one passed paper behind them.
  Set<String> get _passedLevels => {
    for (final a in _history)
      if (a.result.passed) a.exam.level.toLowerCase(),
  };

  /// The sections this exam contains, in sit order. Reading and listening each
  /// arrive as two parts but share one page.
  List<ExamSection> get _sections {
    final seen = <ExamSection>[];
    for (final part in _exam!.parts) {
      if (!seen.contains(part.section)) seen.add(part.section);
    }
    return seen;
  }

  // Resolved eagerly: a `late final … = context.read()` would only run on first
  // use, and dispose() reads _tts — by then the element is deactivated and the
  // lookup throws.
  late final TtsService _tts;
  late final SettingsRepository _settings;

  @override
  void initState() {
    super.initState();
    _tts = context.read<TtsService>();
    _settings = context.read<SettingsRepository>();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _settings.examAttempts();
    if (mounted) setState(() => _history = history);
  }

  @override
  void dispose() {
    for (final c in _writing.values) {
      c.dispose();
    }
    _tts.stop();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() {
      _phase = _Phase.generating;
      _error = null;
      _answers.clear();
      _step = 0;
    });
    try {
      final exam = await context.read<AiService>().generateExam(level: _level);
      if (!mounted) return;
      if (exam.parts.isEmpty || exam.allQuestions.isEmpty) {
        throw AiException('A vizsga üresen érkezett. Próbáld újra.');
      }
      setState(() {
        _exam = exam;
        _phase = _Phase.filling;
      });
    } on AiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.messageHu;
        _phase = _Phase.setup;
      });
    }
  }

  Future<void> _submit() async {
    final exam = _exam!;
    for (final entry in _writing.entries) {
      _answers[entry.key] = entry.value.text.trim();
    }

    final unanswered = exam.allQuestions
        .where((q) => (_answers[q.id] ?? '').isEmpty)
        .length;
    if (unanswered > 0 && !await _confirmIncomplete(unanswered)) return;

    if (!mounted) return;
    _tts.stop();
    setState(() {
      _phase = _Phase.grading;
      _error = null;
    });
    try {
      final graded = await context.read<AiService>().gradeExam(
        exam: exam,
        answers: _answers,
      );
      if (!mounted) return;
      final attempt = ExamAttempt(
        takenAt: DateTime.now(),
        exam: exam,
        answers: Map.of(_answers),
        marks: graded.marks,
        feedbackHu: graded.feedbackHu,
      );
      setState(() {
        _result = attempt.result;
        _phase = _Phase.result;
      });
      // Filing the paper is a bonus — a failed write must not disturb the
      // result already on screen.
      try {
        await _settings.saveExamAttempt(attempt);
        await _loadHistory();
      } catch (_) {}
    } on AiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.messageHu;
        _phase = _Phase.filling;
      });
    }
  }

  Future<bool> _confirmIncomplete(int count) async {
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Beadod így?'),
        content: Text('$count kérdés még üres. Az üres válasz 0 pontot ér.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vissza'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Beadás'),
          ),
        ],
      ),
    );
    return go ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (_phase) {
          _Phase.result => 'Eredmény',
          _Phase.filling || _Phase.grading => '${_level.toUpperCase()} vizsga',
          _ => 'Szintvizsga',
        }),
      ),
      body: switch (_phase) {
        _Phase.setup => _setup(),
        _Phase.generating => _busy(
          'Vizsga összeállítása…',
          'Ez fél percig is eltarthat, az AI most írja a feladatokat.',
        ),
        _Phase.filling => _filling(),
        _Phase.grading => _busy(
          'Javítás folyamatban…',
          'Az AI átnézi a válaszaidat és megindokolja a hibákat.',
        ),
        _Phase.result => _resultView(),
      },
    );
  }

  Widget _busy(String title, String subtitle) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    ),
  );

  Widget _setup() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Szintvizsga', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
          'Öt rész, mindegyik külön képernyőn: 20 nyelvtan, 20 szókincs, két '
          'olvasott szöveg, két hangfelvétel és két írásbeli feladat. A '
          'képernyők között oda-vissza lépkedhetsz, a végén adod be az '
          'egészet. Az AI kijavítja, és minden hibát megindokol.',
        ),
        const SizedBox(height: 24),
        Text('Szint', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: [
            for (final level in examLevels)
              ButtonSegment(value: level, label: Text(level.toUpperCase())),
          ],
          selected: {_level},
          onSelectionChanged: (s) => setState(() => _level = s.first),
        ),
        const SizedBox(height: 16),
        _passedBadges(),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Megfeleléshez',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Minden részben legalább '
                  '${ExamResult.minimumPercent}%',
                ),
                const Text(
                  '• Átlagban legalább '
                  '${ExamResult.passAveragePercent}%',
                ),
              ],
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Vizsga indítása'),
        ),
        if (_history.isNotEmpty) ...[
          const Divider(height: 40),
          Text(
            'Korábbi vizsgák',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const Text('Nyisd meg bármelyiket a kijavított válaszokért.'),
          for (final attempt in _history) _historyTile(attempt),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  /// Which levels are already in the bag. A level counts as passed once any
  /// paper at that level passed — it cannot be lost by failing a later one.
  Widget _passedBadges() {
    final scheme = Theme.of(context).colorScheme;
    final passed = _passedLevels;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final level in examLevels)
          Chip(
            avatar: Icon(
              passed.contains(level) ? Icons.verified : Icons.lock_outline,
              size: 18,
              color: passed.contains(level) ? Colors.green : scheme.outline,
            ),
            label: Text(
              '${level.toUpperCase()} '
              '${passed.contains(level) ? 'teljesítve' : 'még nincs meg'}',
            ),
          ),
      ],
    );
  }

  Widget _historyTile(ExamAttempt attempt) {
    final result = attempt.result;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        result.passed ? Icons.verified : Icons.replay,
        color: result.passed ? Colors.green : scheme.error,
      ),
      title: Text(
        '${attempt.exam.level.toUpperCase()} — ${result.averagePercent}%',
      ),
      subtitle: Text(_dateHu(attempt.takenAt)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => setState(() {
        _exam = attempt.exam;
        _answers
          ..clear()
          ..addAll(attempt.answers);
        _result = result;
        _phase = _Phase.result;
      }),
    );
  }

  /// ponytail: one date format, so no intl dependency.
  static String _dateHu(DateTime d) {
    String two(int n) => '$n'.padLeft(2, '0');
    return '${d.year}. ${two(d.month)}. ${two(d.day)}. '
        '${two(d.hour)}:${two(d.minute)}';
  }

  /// One section per page, with the questions of every part in that section.
  Widget _filling() {
    final sections = _sections;
    final step = _step.clamp(0, sections.length - 1);
    final parts = _exam!.parts
        .where((p) => p.section == sections[step])
        .toList();

    // Numbering runs across the whole page, so two reading passages read as
    // questions 1-5 and 6-10 rather than restarting.
    var number = 0;
    final children = <Widget>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0) children.add(const Divider(height: 32));
      children.addAll(_partIntro(parts[i], i, parts.length));
      for (final q in parts[i].questions) {
        children.add(_question(q, ++number));
      }
    }

    return Column(
      children: [
        _stepHeader(sections, step, parts),
        Expanded(
          child: ListView(
            // A new list per page, so each section opens at the top.
            key: ValueKey(step),
            padding: const EdgeInsets.all(16),
            children: children,
          ),
        ),
        _stepNav(step, sections.length),
      ],
    );
  }

  Widget _stepHeader(List<ExamSection> sections, int step, List<ExamPart> parts) {
    final scheme = Theme.of(context).colorScheme;
    final choices = [
      for (final p in parts)
        for (final q in p.questions)
          if (!q.isFreeText) q,
    ];
    final answered = choices
        .where((q) => (_answers[q.id] ?? '').isNotEmpty)
        .length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < sections.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: i <= step
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${step + 1}/${sections.length} — ${sections[step].labelHu}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (choices.isNotEmpty)
            Text(
              '$answered/${choices.length} megválaszolva',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }

  Widget _stepNav(int step, int stepCount) {
    final last = step == stepCount - 1;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) ...[
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                if (step > 0) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _goTo(step - 1),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Vissza'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: last
                      ? FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.check),
                          label: const Text('Beadás'),
                        )
                      : FilledButton.icon(
                          onPressed: () => _goTo(step + 1),
                          icon: const Icon(Icons.arrow_forward),
                          iconAlignment: IconAlignment.end,
                          label: const Text('Tovább'),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _goTo(int step) {
    // No script left talking over the next section.
    _tts.stop();
    setState(() {
      _step = step;
      _error = null;
    });
  }

  /// Instructions and the text or recording this part is built on.
  List<Widget> _partIntro(ExamPart part, int index, int count) {
    final listening = part.section == ExamSection.listening;
    return [
      if (count > 1)
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            listening ? '${index + 1}. hangfelvétel' : '${index + 1}. szöveg',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      if (part.instructionsHu.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            part.instructionsHu,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      // The listening script is never shown — only played.
      if (listening && part.passage.isNotEmpty)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.headphones),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Hallgasd meg, ahányszor csak szeretnéd.'),
                ),
                FilledButton.tonal(
                  onPressed: () => _tts.speak(part.passage),
                  child: const Text('Lejátszás'),
                ),
              ],
            ),
          ),
        ),
      if (!listening && part.passage.isNotEmpty)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (part.passageTitle.isNotEmpty)
                  Text(
                    part.passageTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 8),
                Text(part.passage),
              ],
            ),
          ),
        ),
    ];
  }

  Widget _question(ExamQuestion q, int number) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number. ${q.prompt}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (q.isFreeText)
              TextField(
                controller: _writing.putIfAbsent(
                  q.id,
                  () => TextEditingController(),
                ),
                maxLines: 5,
                minLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Írd ide a válaszod angolul…',
                ),
              )
            else
              RadioGroup<String>(
                groupValue: _answers[q.id],
                onChanged: (v) => setState(() => _answers[q.id] = v!),
                child: Column(
                  children: [
                    for (final option in q.options)
                      RadioListTile<String>(
                        value: option,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(option),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _resultView() {
    final result = _result!;
    final exam = _exam!;
    final scheme = Theme.of(context).colorScheme;
    final marks = {for (final m in result.marks) m.id: m};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: result.passed
              ? Colors.green.withValues(alpha: 0.15)
              : scheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  result.passed ? Icons.verified : Icons.replay,
                  size: 48,
                  color: result.passed ? Colors.green : scheme.error,
                ),
                const SizedBox(height: 8),
                Text(
                  result.passed
                      ? 'Sikeres vizsga! ${result.level.toUpperCase()} szint teljesítve.'
                      : 'Még nem sikerült — de közel vagy.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text('Átlag: ${result.averagePercent}%'),
              ],
            ),
          ),
        ),
        // The examiner's note comes before the numbers: it says which part to
        // work on next, which is the point of sitting the exam.
        if (result.overallFeedbackHu.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Értékelés',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(result.overallFeedbackHu),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        for (final s in result.sections)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              s.meetsMinimum ? Icons.check_circle : Icons.error_outline,
              color: s.meetsMinimum ? Colors.green : scheme.error,
            ),
            title: Text(s.section.labelHu),
            subtitle: LinearProgressIndicator(value: s.percent / 100),
            trailing: Text(
              '${s.percent}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        if (!result.passed) ...[
          const SizedBox(height: 8),
          Text(
            result.failedSections.isEmpty
                ? 'Az átlagod ${result.averagePercent}%, '
                      '${ExamResult.passAveragePercent}% kell a továbblépéshez.'
                : 'Ezekben a részekben nem érted el a '
                      '${ExamResult.minimumPercent}%-ot: '
                      '${result.failedSections.map((s) => s.section.labelHu).join(', ')}.',
          ),
        ],
        const Divider(height: 32),
        Text('Válaszok', style: Theme.of(context).textTheme.titleMedium),
        for (final part in exam.parts)
          for (final q in part.questions)
            _markCard(q, marks[q.id], _answers[q.id] ?? ''),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => setState(() {
            _phase = _Phase.setup;
            _exam = null;
            _result = null;
            _step = 0;
            _answers.clear();
            for (final c in _writing.values) {
              c.clear();
            }
          }),
          icon: const Icon(Icons.refresh),
          label: const Text('Új vizsga'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _markCard(ExamQuestion q, QuestionMark? mark, String given) {
    final scheme = Theme.of(context).colorScheme;
    final correct = mark?.isCorrect ?? false;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  correct ? Icons.check_circle : Icons.cancel,
                  size: 20,
                  color: correct ? Colors.green : scheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(q.prompt)),
                if (mark != null && q.isFreeText)
                  Text(
                    '${mark.score}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'A válaszod: ${given.isEmpty ? '(üres)' : given}',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            if (!correct && (mark?.expected.isNotEmpty ?? false)) ...[
              const SizedBox(height: 4),
              Text(
                'Helyes: ${mark!.expected}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
            if (mark != null && mark.explanationHu.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(mark.explanationHu),
            ],
          ],
        ),
      ),
    );
  }
}
