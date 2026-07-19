# Data sources & licenses

The bundled learning content is derived from open, license-safe sources.
Attribution is also shown in the app's About screen.

## Vocabulary

- **Word list & CEFR levels** — CEFR-J Wordlist v1.5
  (github.com/openlanguageprofiles/olp-en-cefrj). © CEFR-J. Licensed under
  **CC BY-SA 4.0**.
- **Frequency ranking** — `wordfreq` (github.com/rspeer/wordfreq), used at build
  time to order words by commonness. **CC BY-SA 4.0**.
- **English→Hungarian translations** — inverted from a Hungarian→English
  dictionary generated from **Wiktionary** content. Wiktionary text is
  **CC BY-SA 4.0**, © Wikimedia Foundation and contributors. The most common
  words were additionally hand-verified (`tool/overrides.json`).

Because CEFR-J, wordfreq and Wiktionary are all CC BY-SA 4.0, the derived
`vocabulary.json` is distributed under **CC BY-SA 4.0**.

## Grammar lessons

Authored for this project from the standard A1–B1 English grammar syllabus;
explanations in Hungarian, examples in English. Original content.

## Runtime services

- **Text-to-speech** — the device's platform TTS engine via `flutter_tts`.
- **AI sentence evaluation & reading generation** — OpenRouter (OpenAI-compatible
  API), using a user-supplied API key provided at build time via
  `--dart-define=OPENROUTER_API_KEY`.

## Rebuilding vocabulary.json

    pip install mobi beautifulsoup4 wordfreq
    python tool/build_vocab.py --mobi "path/to/Hungarian-English Wiktionary dictionary.mobi"
