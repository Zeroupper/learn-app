import 'package:flutter/material.dart';

import '../models/reading_exercise.dart';
import 'feedback_style.dart';

/// A multiple-choice question with instant colored feedback. Shared by the
/// reading and listening screens.
class McQuestionCard extends StatefulWidget {
  final ReadingQuestion question;
  const McQuestionCard(this.question, {super.key});

  @override
  State<McQuestionCard> createState() => _McQuestionCardState();
}

class _McQuestionCardState extends State<McQuestionCard> {
  int? _chosen;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.question,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (var i = 0; i < q.options.length; i++) _option(i, q),
          ],
        ),
      ),
    );
  }

  Widget _option(int i, ReadingQuestion q) {
    Color? bg;
    if (_chosen != null) {
      if (i == q.correctIndex) {
        bg = feedbackColors(context, FeedbackKind.correct).bg;
      } else if (i == _chosen) {
        bg = feedbackColors(context, FeedbackKind.wrong).bg;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: _chosen == null ? () => setState(() => _chosen = i) : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bg,
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(q.options[i]),
        ),
      ),
    );
  }
}
