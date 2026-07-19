import 'package:flutter/material.dart';

import '../controllers/study_controller.dart';
import 'feedback_style.dart';

/// The colored result banner shown after checking an answer.
/// Green = correct, amber = accent-only "almost", red = wrong.
class AnswerFeedbackBanner extends StatelessWidget {
  final StudyPhase phase;
  final StudyPrompt prompt;
  final String userAnswer;
  final void Function(String english) onSpeak;
  final VoidCallback onProceed;

  const AnswerFeedbackBanner({
    super.key,
    required this.phase,
    required this.prompt,
    required this.userAnswer,
    required this.onSpeak,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final (kind, title, icon) = switch (phase) {
      StudyPhase.correct => (FeedbackKind.correct, 'Helyes!', Icons.check_circle),
      StudyPhase.almost => (FeedbackKind.almost, 'Majdnem!', Icons.info),
      StudyPhase.wrong => (FeedbackKind.wrong, 'Nem helyes', Icons.cancel),
      _ => (FeedbackKind.neutral, '', Icons.help),
    };
    final (:bg, :fg) = feedbackColors(context, kind);
    final isWrong = phase == StudyPhase.wrong;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: fg, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Icon(icon, color: fg),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                    color: fg, fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          if (phase == StudyPhase.almost)
            Text('Helyesen: ${prompt.answerText}',
                style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
          if (isWrong) ...[
            Text(userAnswer,
                style: TextStyle(
                    color: fg,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: fg)),
            const SizedBox(height: 2),
            Row(children: [
              Flexible(
                child: Text(prompt.answerText,
                    style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
              ),
              _speakButton(fg),
            ]),
          ],
          if (phase == StudyPhase.correct)
            Row(children: [
              Flexible(
                child: Text(prompt.answerText, style: TextStyle(color: fg)),
              ),
              _speakButton(fg),
            ]),
          if (prompt.word.exampleEn != null) ...[
            const SizedBox(height: 8),
            Row(children: [
              Flexible(
                child: Text(prompt.word.exampleEn!,
                    style: TextStyle(color: fg, fontStyle: FontStyle.italic)),
              ),
              IconButton(
                icon: Icon(Icons.volume_up, color: fg, size: 20),
                onPressed: () => onSpeak(prompt.word.exampleEn!),
              ),
            ]),
            if (prompt.word.exampleHu != null)
              Text(prompt.word.exampleHu!,
                  style: TextStyle(color: fg, fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onProceed,
              child: Text(isWrong ? 'Megértettem' : 'Tovább'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _speakButton(Color fg) => IconButton(
        icon: Icon(Icons.volume_up, color: fg, size: 20),
        onPressed: () => onSpeak(prompt.englishText),
      );
}
