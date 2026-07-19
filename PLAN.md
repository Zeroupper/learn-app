# Hungarian→English Learning App (learn_app) — Implementation Plan

## Context

The repo is a freshly scaffolded Flutter project (Android target, default counter app, no dependencies). The user wants a personal language-learning app for a Hungarian speaker learning English, covering CEFR levels A1→B1:

- **Flashcards** with the most common English words + Hungarian translations, studied in both directions (EN→HU and HU→EN); on a wrong answer, show the correct solution Duolingo-style and re-queue the card.
- **Spaced repetition** (SM-2 style) so failed cards return soon and known cards spread out.
- **Progress indicator** — dashboard showing words mastered per level, overall progress, reviews done today.
- **Grammar school** — ~14 bundled offline grammar lessons targeting Hungarian-speaker pain points (explanations in Hungarian).
- **AI sentence practice** — user writes English sentences on a topic at a chosen level; Claude evaluates (corrections + explanation in Hungarian + score).
- **AI reading texts** — Claude generates a level-matched (A1/A2/B1) reading text for a chosen topic.

Decisions confirmed with the user: API key pasted into a Settings screen (stored on-device); ~2000 bundled words (≈600 A1 / 700 A2 / 700 B1); grammar lessons bundled offline while reading texts are AI-generated on demand; SM-2 spaced repetition.

Later additions from the user:
- **Text-to-speech everywhere**: an audio icon next to English content (flashcard words, examples, reading texts, corrected sentences) using the device's Google TTS engine via `flutter_tts` — free, no API key.
- **AI backend = OpenRouter**, not the Anthropic API key. The user asked about Claude subscription OAuth for cheaper pricing; that is not feasible for a custom app (subscription OAuth is restricted to official Anthropic clients, would need a fragile PKCE + refresh flow), so per the user's stated fallback we use an **OpenRouter API key** — cheaper models selectable, OpenAI-compatible endpoint.

## Data sources (researched, license-safe)

Per the user: source **general English** content (common words, standard grammar syllabus) — no Hungarian-specific datasets needed. Hungarian translations are produced by us afterward (one-off Claude batch pass during implementation, then spot-checked).

| Data | Source | License |
|---|---|---|
| CEFR-tagged common English words | CEFR-J Wordlist CSV — `github.com/openlanguageprofiles/olp-en-cefrj` (~7,800 lemmas, A1–B2, general English) | CC BY-SA 4.0 |
| Frequency ordering | `rspeer/wordfreq` data | CC BY-SA 4.0 |
| EN→HU translations | Generated at build time with a one-off Claude batch pass over the selected ~2000 words (word + POS + example → best Hungarian translation(s)); spot-checked manually | n/a (our own data) |
| Example sentences (optional) | Tatoeba EN sentences, or Claude-generated alongside translations | CC BY 2.0 FR / n/a |

Avoid: Oxford 3000/5000 (© OUP, no open license — cross-check only), Anki shared decks (unclear licensing). Attribution for CC BY-SA data goes in an About screen.

Grammar lessons: standard English A1–B1 grammar syllabus (~14 lessons), authored in English during implementation, then translated to Hungarian (explanations in Hungarian, examples stay in English): articles a/an/the; to be; there is/are; SVO word order; present simple vs continuous; question formation with do/does/did; prepositions of place/time (in/on/at); past simple; present perfect vs past simple; will vs going to; countable/uncountable + some/any/much/many; personal pronouns he/she/it; comparatives/superlatives; modals + first conditional.

## AI backend: OpenRouter (constraints)

- **Raw HTTP** via the `http` package: `POST https://openrouter.ai/api/v1/chat/completions`, headers `Authorization: Bearer <key>`, `content-type: application/json` (OpenAI-compatible).
- **Model is user-configurable in Settings**; default `anthropic/claude-haiku-4.5` (cheap, good enough for A1–B1 evaluation), with a free-text override field so the user can pick any OpenRouter model (e.g. `anthropic/claude-sonnet-4.6` for higher quality).
- Structured results via `response_format: {type: "json_schema", json_schema: {name, strict: true, schema}}` (`additionalProperties: false` + `required`). Fallback for models that ignore it: instruct JSON-only output in the prompt and parse defensively (strip code fences, `jsonDecode`, surface a "try again" error on failure).
- `max_tokens` ~2048 (evaluation) / 4096 (reading), non-streaming.
- Error handling: 401 → "check your API key in Settings"; 402 (OpenRouter out of credits) → clear message; 429 → respect `retry-after`, one retry; 5xx → backoff retry; 25s timeout → network error message.
- API key stored with `flutter_secure_storage`; AI screens show a friendly "add your key in Settings" state when absent.

## Text-to-speech (`flutter_tts`)

- Uses the platform TTS engine (Google TTS on Android) — free, works offline, no key.
- Small `tts_service.dart`: `speak(String text)` with language `en-US`, plus stop-on-new-speak; graceful no-op if the engine/language is missing (with a one-time hint to install Google TTS voices).
- Audio icon placement: flashcard prompt & answer (English side), example sentences, grammar lesson examples, AI reading text (whole text + per-tapped word), the corrected sentence in evaluations.

## Design decisions

1. **Persistence: sqflite (+ `path`).** Single user, ~4,000 review-state rows (2,000 words × 2 directions), simple queries. The vocabulary itself stays a bundled JSON asset loaded into memory at startup — only mutable state (review states, review log, key-value settings) lives in SQLite.
2. **State management: plain `ChangeNotifier` + `provider`.** One small stable dependency; controllers are plain Dart classes, unit-testable without pumping widgets.
3. **Answer checking: normalized match against a list of accepted answers.** `hu` (and `enAccepted`) are `List<String>`. Normalization: NFC, lowercase, trim, collapse whitespace, strip terminal punctuation, optional prefixes ("to " for EN verbs, "a "/"az " for HU). Accents are significant in Hungarian (kor/kór/kör differ), so an accent-only mismatch grades as "almost": passes (q=4) but an amber banner shows the correct form.
4. **Navigation: bottom `NavigationBar`, 5 tabs** — Home (dashboard), Cards, Grammar, AI, Settings. Study session is pushed as a full-screen route above the shell.

## Dependencies (pubspec additions)

```yaml
dependencies:
  http: ^1.2.0                    # raw HTTP to OpenRouter chat completions
  sqflite: ^2.4.0
  path: ^1.9.0
  flutter_secure_storage: ^9.2.0
  flutter_tts: ^4.0.0             # Google TTS engine on Android
  provider: ^6.1.0
flutter:
  assets:
    - assets/data/vocabulary.json
    - assets/data/grammar/
```

Android: `android/app/build.gradle.kts` → `minSdk = 23` (flutter_secure_storage requirement); add `<uses-permission android:name="android.permission.INTERNET"/>` to the **main** `android/app/src/main/AndroidManifest.xml` (only debug manifests have it — release builds can't reach the API otherwise).

## File structure

```
tool/                              # build-time pipeline (Python), not shipped
  build_vocab.py                   # CEFR-J + wordfreq → word selection
  translate_vocab.py               # Claude batch: EN → HU translations for all ~2000 words
assets/data/
  vocabulary.json                  # ~2000 entries (committed)
  LICENSES.md                      # CC BY-SA attributions
  grammar/index.json + 01_articles.json ... 14_modals_conditional.json
lib/
  main.dart                        # bootstrap: open DB, load repos, runApp
  app.dart                         # MaterialApp + HomeShell (NavigationBar, 5 tabs)
  models/       vocab_word.dart, review_state.dart, grammar_lesson.dart,
                evaluation_result.dart, reading_exercise.dart
  data/         app_database.dart, vocab_repository.dart, grammar_repository.dart,
                srs_repository.dart, settings_repository.dart
  services/     srs_scheduler.dart (pure), answer_checker.dart (pure),
                session_builder.dart, api_key_store.dart, ai_service.dart, tts_service.dart
  controllers/  study_controller.dart, dashboard_controller.dart, settings_controller.dart,
                sentence_practice_controller.dart, reading_controller.dart
  screens/      home_screen.dart, study_setup_screen.dart, study_screen.dart,
                grammar_list_screen.dart, grammar_lesson_screen.dart, ai_hub_screen.dart,
                sentence_practice_screen.dart, reading_screen.dart, settings_screen.dart,
                about_screen.dart
  widgets/      answer_feedback_banner.dart, level_progress_card.dart, api_key_gate.dart
test/           srs_scheduler_test.dart, answer_checker_test.dart, session_builder_test.dart,
                ai_service_test.dart, study_screen_test.dart
```

## Data models & storage

```dart
enum CefrLevel { a1, a2, b1 }
enum Direction { enToHu, huToEn }          // stored as 'en_hu' / 'hu_en'

class VocabWord { id, en, enAccepted: List<String>, hu: List<String>,
                  level, pos, exampleEn?, exampleHu? }
class ReviewState { wordId, direction,      // PK = (wordId, direction)
                    repetitions, easeFactor /*start 2.5, floor 1.3*/,
                    intervalDays, dueAt /*null = new*/, lapses, lastReviewedAt;
                    isMastered => intervalDays >= 21 }
class GrammarLesson { id, titleHu, subtitleHu, level, sections /*headingHu, bodyHu,
                      examples: [{en, hu}]*/, exercises /*promptHu, options,
                      correctIndex, explanationHu*/ }   // structured JSON, not markdown
class SentenceEvaluation { score /*0-100*/, isCorrect, corrected,
                           errors /*{original, corrected, explanationHu}*/, explanationHu }
class ReadingExercise { title, text, questions /*{question, options[3], correctIndex}*/,
                        glossary /*{en, hu}*/ }
```

SQLite schema v1: `review_state(word_id, direction, repetitions, ease_factor, interval_days, due_at, lapses, last_reviewed_at, PK(word_id, direction))` + index on `due_at`; `review_log(id, word_id, direction, reviewed_at, quality)` + index on `reviewed_at`; `settings(key, value)`. Word metadata stays in the JSON asset; stats join in Dart (trivial at 2k rows).

## SM-2 adapted for two directions

Each (word, direction) is an independent card. `srs_scheduler.dart` is pure: `applyReview(state, quality, now)`.

- **Quality mapping:** correct first attempt → q=5; accent-only "almost" → q=4; correct only after in-session failure → q=3; wrong → q=1. Only the first attempt per card per session is graded/persisted.
- **Pass (q≥3):** repetitions+=1; interval = 1d (rep 1), 6d (rep 2), else round(interval×EF); EF' = EF + (0.1 − (5−q)(0.08 + (5−q)·0.02)), clamp ≥ 1.3; dueAt = now + interval.
- **Fail (q<3):** lapses+=1; repetitions=0; interval=0; dueAt = now + 10 min; EF reduced, clamp 1.3.
- **Session queue** (`session_builder.dart`): due cards for chosen direction(s)/level, cap 20, oldest-due first; fill with up to 10 new cards (frequency order = asset order). "Mixed" interleaves directions. Failed cards re-inserted ~3 positions ahead until answered correctly.
- **Mastered** = interval ≥ 21 days per direction; word fully mastered when both directions are.

## AI service (`ai_service.dart`, OpenRouter)

Single class, injected `http.Client` for tests, API key + model name read from settings/secure storage.

- `POST https://openrouter.ai/api/v1/chat/completions`; headers `Authorization: Bearer <key>`, `content-type: application/json`; `model` from settings (default `anthropic/claude-haiku-4.5`); non-streaming; `max_tokens` 2048 (evaluation) / 4096 (reading).
- **Structured outputs** via `response_format: {type: "json_schema", json_schema: {name, strict: true, schema}}` (`additionalProperties: false` + full `required`); response text read from `choices[0].message.content`. Defensive parse fallback (strip code fences) for models that ignore `response_format`.
- Response handling order: HTTP status → `finish_reason == "length"` (suggest retry) → parse → `fromJson`; empty/refused content → friendly HU error.
- Typed errors: 401 → "Érvénytelen API kulcs" + link to Settings; 402 → "nincs elég OpenRouter kredit"; 429 → honor `retry-after`, one auto-retry; 5xx → exponential backoff (2 retries); 25s timeout → network error message.

**evaluateSentence({topic, level, sentence})** — system prompt: English teacher for Hungarian speakers, evaluate at CEFR {level}, explanations in Hungarian. Schema: `{score:int, is_correct:bool, corrected:string, errors:[{original, corrected, explanation_hu}], explanation_hu:string}`.

**generateReading({topic, level})** — text sized by level (A1 ~60–90 / A2 ~100–140 / B1 ~150–200 words), 3 multiple-choice questions, glossary of the 8–12 hardest words with HU translations. Tap-to-translate: text rendered as tappable word spans; lookup = returned glossary → bundled vocabulary → "nincs találat". No per-tap API calls.

**API key:** `api_key_store.dart` wraps flutter_secure_storage; Settings has obscured field + Save/Test/Delete (Test = minimal call); `ApiKeyGate` widget disables AI screens with a friendly HU prompt until a key exists.

## Vocabulary pipeline (build-time, `tool/`, outputs committed)

Per the user: general-English sources only; we translate everything to Hungarian ourselves.

1. `build_vocab.py`: CEFR-J Wordlist CSV (CC BY-SA 4.0) → A1/A2/B1 lemmas + POS → rank by `wordfreq` zipf (fallback: CSV order) → top ~600 A1 / 700 A2 / 700 B1, with a short English example sentence per word (Tatoeba or Claude-generated in step 2).
2. `translate_vocab.py`: one-off batch pass through OpenRouter (chunks of ~50 words; word + POS + example → up to 3 Hungarian translations + HU example translation), json_schema response format; use a strong model for this one-time step (e.g. `anthropic/claude-sonnet-4.6`) since translation quality is baked into the shipped asset. Human spot-check of a sample + suspicious entries → emit `vocabulary.json`.
3. Attribution: `assets/data/LICENSES.md` + About screen (CEFR-J, wordfreq, Tatoeba if used).
4. Grammar: 14 lessons authored in English from the standard A1–B1 syllabus, then translated to Hungarian (explanations HU, examples EN+HU); JSON files per the confirmed topic list (`index.json` order: ~1–6 A1, 7–11 A2, 12–14 B1), each with 3–5 multiple-choice self-checks.

## Screens & key flows

- **Home**: overall progress ring, per-level cards (mastered/started/total), "Ma: N ismétlés", streak (consecutive days with ≥1 review), due count + Start button.
- **Study setup**: EN→HU / HU→EN / Vegyes segmented control, level chips, due/new counts.
- **StudyScreen (Duolingo-style loop)**, `StudyController` state machine (prompting → checked(correct|almost|wrong) → finished): progress bar; prompt card (word, POS chip, direction indicator, **audio icon speaking the English side via TTS**); autofocus TextField + "Ellenőrzés".
  - Correct → green banner ("Helyes!" + translation + example, audio icon on the English example) → "Tovább".
  - Almost → amber banner "Majdnem! Helyesen: …" (accented chars highlighted), counts as pass.
  - **Wrong** → red banner: user answer struck through, correct answer(s) bold, example pair; a required "Megértettem" button to proceed; card re-inserted ~3 positions later.
  - Finished → session summary → pop.
- **Grammar list/lesson**: grouped by level; sections then exercises with instant feedback + HU explanation; audio icons on English examples; completion stored in settings table.
- **AI hub** (behind `ApiKeyGate`) → **Sentence practice** (topic chips + level + multiline input → score badge, per-error cards original→corrected + HU explanation, audio icon on the corrected sentence) and **Reading** (topic + level → tappable text with a listen-to-text button → bottom-sheet translations → MC questions).
- **Settings**: OpenRouter API key section (obscured field, Save/Test/Delete), AI model field (default `anthropic/claude-haiku-4.5`), daily new-card cap, About link. **About**: attributions.

## Build order (runnable after every phase)

- **Phase 0** — deps, minSdk 23, INTERNET permission, replace counter app with 5-tab shell; `flutter analyze` + `flutter build apk --debug` pass.
- **Phase 1** — data pipeline → committed `vocabulary.json`; models; database + repositories; Home shows loaded word count.
- **Phase 2** — SM-2 scheduler, answer checker, session builder (pure + unit-tested first); StudyController; setup + study screens with full wrong-answer flow; persistence; TTS service + audio icons on flashcards.
- **Phase 3** — dashboard stats queries + Home UI (mastered per level, due, today, streak).
- **Phase 4** — 14 grammar lesson JSONs; grammar screens + completion tracking.
- **Phase 5** — API key store + Settings UI (key + model); AiService (+ mocked-client tests); sentence practice; reading with tap-to-translate + listen button.
- **Phase 6** — polish: About/licenses, empty/error/loading states, theming, final checks.

## Verification

- **Unit tests**: SM-2 (interval 1→6→EF-scaled, EF floor, lapse reset, quality mapping); answer normalization (case/whitespace/punctuation/accepted-list/accent-almost/"to "-prefix/"a-az"); session builder (ordering, caps, re-queue offset, mixed); AiService with mocked `http.Client` (exact request shape incl. model + Authorization header, schema parse, 401/402/429/5xx/malformed-JSON branches — no network).
- **Widget test**: study flow — wrong answer → red banner + required "Megértettem" → card reappears → correct → session finishes.
- `flutter analyze` clean, `flutter test` green; smoke-run `flutter run` on an Android emulator if available, otherwise `flutter build apk --debug` must succeed.
- Manual on-device check of one real sentence evaluation and one reading generation with a real API key.
