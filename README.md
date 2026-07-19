# learn_app — Angol tanulás magyaroknak

Personal Hungarian→English learning app (CEFR A1–B1): spaced-repetition
flashcards, offline grammar lessons, and AI sentence practice + reading.

## Run

The OpenRouter API key is provided at build time (never stored on device).
Copy `.env.example` to `.env` and paste your key:

```bash
cp .env.example .env
# edit .env → OPENROUTER_API_KEY=sk-or-...
```

Then build/run with the env file:

```bash
flutter run --dart-define-from-file=.env
flutter build apk --release --dart-define-from-file=.env
```

`.env` is gitignored. Without a key the app still works fully offline
(flashcards + grammar); only the AI tab is disabled.

## Tests

```bash
flutter test
flutter analyze
```

## Rebuilding the vocabulary

`assets/data/vocabulary.json` (2000 words) is generated offline from the CEFR-J
wordlist + a Wiktionary `.mobi` dictionary. See `assets/data/LICENSES.md`:

```bash
pip install mobi beautifulsoup4 wordfreq
python tool/build_vocab.py --mobi "path/to/Hungarian-English Wiktionary dictionary.mobi"
```

Common words are hand-verified in `tool/overrides.json`.
