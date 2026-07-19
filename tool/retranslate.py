#!/usr/bin/env python3
"""Re-translate vocabulary.json EN->HU via OpenRouter, in parallel batches.

Fixes the noisy offline-dictionary inversion with proper LLM translations.
Reads the API key from .env (OPENROUTER_API_KEY). Hand-verified entries in
tool/overrides.json always win.

Usage: python tool/retranslate.py [--model anthropic/claude-haiku-4.5]
"""
import argparse
import json
import re
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

VOCAB = Path("assets/data/vocabulary.json")
OVERRIDES = Path("tool/overrides.json")
ENV = Path(".env")
URL = "https://openrouter.ai/api/v1/chat/completions"
BATCH = 60
WORKERS = 6

SYSTEM = (
    "You are an expert English->Hungarian translator making flashcards for a "
    "Hungarian learner (CEFR A1-B1). For each English word return its 2-3 most "
    "common, natural Hungarian translations for the word's MOST COMMON EVERYDAY "
    "meaning, most common sense first, INCLUDING everyday synonyms so the "
    "learner's answer is accepted. Examples: 'make' -> ['csinálni','készíteni'], "
    "'run' -> ['futni','szaladni'], 'take' -> ['venni','elvinni','fogni'], "
    "'look' -> ['nézni','pillantani'], 'play' -> ['játszani'], 'open' -> "
    "['kinyitni','nyitni']. If a word is commonly a verb, give the verb sense as "
    "an infinitive (e.g. 'to eat' -> 'enni'). No slang, no rare senses. Return "
    "JSON only."
)

SCHEMA = {
    "type": "object",
    "additionalProperties": False,
    "required": ["items"],
    "properties": {
        "items": {
            "type": "array",
            "items": {
                "type": "object",
                "additionalProperties": False,
                "required": ["id", "hu"],
                "properties": {
                    "id": {"type": "integer"},
                    "hu": {"type": "array", "items": {"type": "string"}},
                },
            },
        }
    },
}


def api_key():
    for line in ENV.read_text().splitlines():
        if line.startswith("OPENROUTER_API_KEY="):
            return line.split("=", 1)[1].strip()
    raise SystemExit("OPENROUTER_API_KEY not found in .env")


def translate_batch(key, model, batch):
    ask = [{"id": w["id"], "en": w["en"]} for w in batch]
    payload = {
        "model": model,
        "max_tokens": 4096,
        "messages": [
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": json.dumps(ask, ensure_ascii=False)},
        ],
        "response_format": {
            "type": "json_schema",
            "json_schema": {"name": "tr", "strict": True, "schema": SCHEMA},
        },
    }
    req = urllib.request.Request(
        URL,
        data=json.dumps(payload).encode(),
        headers={"Authorization": f"Bearer {key}",
                 "content-type": "application/json"},
    )
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=120) as r:
                body = json.loads(r.read())
            content = body["choices"][0]["message"]["content"]
            content = re.sub(r"^```[a-z]*\s*|\s*```$", "", content.strip())
            return {i["id"]: i["hu"] for i in json.loads(content)["items"]}
        except Exception as e:  # noqa: BLE001
            if attempt == 2:
                print("  batch failed:", e)
                return {}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="anthropic/claude-haiku-4.5")
    args = ap.parse_args()

    key = api_key()
    words = json.loads(VOCAB.read_text())
    overrides = {k: v for k, v in json.loads(OVERRIDES.read_text()).items()
                 if not k.startswith("_")}

    batches = [words[i:i + BATCH] for i in range(0, len(words), BATCH)]
    print(f"{len(words)} words in {len(batches)} batches, model {args.model}")

    results = {}
    with ThreadPoolExecutor(max_workers=WORKERS) as ex:
        futures = [ex.submit(translate_batch, key, args.model, b) for b in batches]
        for n, f in enumerate(futures, 1):
            results.update(f.result())
            print(f"  {n}/{len(batches)} done ({len(results)} translated)")

    missing = 0
    for w in words:
        if w["en"] in overrides:
            w["hu"] = overrides[w["en"]]           # hand-verified wins
        elif w["id"] in results:
            w["hu"] = results[w["id"]]
        else:
            missing += 1                            # keep old value

    assert all(w["hu"] for w in words)
    VOCAB.write_text(json.dumps(words, ensure_ascii=False, indent=2))
    print(f"Wrote {len(words)} words. Untranslated (kept old): {missing}")


if __name__ == "__main__":
    main()
