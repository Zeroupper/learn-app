import 'package:flutter/material.dart';

enum FeedbackKind { correct, almost, wrong, neutral }

/// Theme-aware (bg, fg) for correct/almost/wrong feedback so the tinted
/// boxes read well in both light and dark mode.
({Color bg, Color fg}) feedbackColors(BuildContext context, FeedbackKind kind) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  final base = switch (kind) {
    FeedbackKind.correct => Colors.green,
    FeedbackKind.almost => Colors.amber,
    FeedbackKind.wrong => Colors.red,
    FeedbackKind.neutral => Colors.grey,
  };
  return dark
      ? (bg: base.shade900.withValues(alpha: 0.40), fg: base.shade200)
      : (bg: base.shade50, fg: base.shade900);
}
