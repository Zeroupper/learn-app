import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Mic button that dictates into [controller] in [localeId] (e.g. 'hu_HU').
/// Renders nothing when the device has no speech recognition.
class DictationButton extends StatefulWidget {
  final TextEditingController controller;
  final String localeId;
  final bool enabled;

  const DictationButton({
    super.key,
    required this.controller,
    required this.localeId,
    this.enabled = true,
  });

  @override
  State<DictationButton> createState() => _DictationButtonState();
}

class _DictationButtonState extends State<DictationButton> {
  final _stt = SpeechToText();
  bool _available = false;
  bool _listening = false;

  /// Bumped whenever a dictation is abandoned, so late results from it
  /// (the engine delivers its final transcript after stopping) are dropped.
  int _session = 0;

  @override
  void initState() {
    super.initState();
    _stt.initialize().then((ok) {
      if (mounted) setState(() => _available = ok);
    });
  }

  @override
  void didUpdateWidget(DictationButton old) {
    super.didUpdateWidget(old);
    if (widget.enabled != old.enabled) _abandon();
  }

  /// Ends any dictation without letting its transcript reach the field.
  void _abandon() {
    _session++;
    if (_listening) {
      _stt.cancel();
      _setListening(false);
    }
  }

  @override
  void dispose() {
    _stt.cancel();
    super.dispose();
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') _setListening(false);
  }

  void _setListening(bool v) {
    if (mounted && _listening != v) setState(() => _listening = v);
  }

  void _onResult(SpeechRecognitionResult r, int session) {
    if (session != _session || !widget.enabled) return;
    widget.controller.value = TextEditingValue(
      text: r.recognizedWords,
      selection: TextSelection.collapsed(offset: r.recognizedWords.length),
    );
  }

  Future<void> _toggle() async {
    if (_listening) {
      await _stt.stop();
      return;
    }
    // SpeechToText is a process-wide singleton that only takes listeners on
    // its first initialize(), so claim them each time we start listening.
    _stt
      ..statusListener = _onStatus
      ..errorListener = (_) => _setListening(false);
    _setListening(true);
    final session = ++_session;
    await _stt.listen(
      onResult: (r) => _onResult(r, session),
      listenOptions: SpeechListenOptions(
        localeId: widget.localeId,
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_available) return const SizedBox.shrink();
    return IconButton(
      tooltip: _listening ? 'Leállítás' : 'Diktálás',
      icon: Icon(_listening ? Icons.mic : Icons.mic_none),
      color: _listening ? Theme.of(context).colorScheme.error : null,
      onPressed: widget.enabled ? _toggle : null,
    );
  }
}
