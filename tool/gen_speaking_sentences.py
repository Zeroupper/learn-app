#!/usr/bin/env python3
"""Generate ~500 read-aloud sentences (A1/A2/B1) for the speaking exercise.

Outputs assets/data/speaking_sentences.json as an ordered list
[{"level": "a1", "text": "..."}, ...] (all A1, then A2, then B1).
Reads the key from .env.

Usage: python tool/gen_speaking_sentences.py [--per-level 167]
"""
import argparse
import json
import re
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

OUT = Path("assets/data/speaking_sentences.json")
ENV = Path(".env")
URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL = "anthropic/claude-haiku-4.5"
CHUNK = 30

SCHEMA = {
    "type": "object", "additionalProperties": False, "required": ["sentences"],
    "properties": {"sentences": {"type": "array", "items": {"type": "string"}}},
}

GUIDE = {
    "a1": "very simple present-tense sentences, 3-7 words, basic everyday vocab, "
          "simple statements and questions (I have a cat. Where is the shop?)",
    "a2": "past and future tenses, 5-10 words, everyday topics, connectors like "
          "and/but/because (I went to the market yesterday. She will call you later.)",
    "b1": "a range of tenses incl. present perfect and conditionals, 8-14 words, "
          "opinions and reasons, more varied vocabulary",
}


def key():
    for line in ENV.read_text().splitlines():
        if line.startswith("OPENROUTER_API_KEY="):
            return line.split("=", 1)[1].strip()
    raise SystemExit("OPENROUTER_API_KEY not found in .env")


def call(k, level, n, seed):
    system = (
        "You write natural ENGLISH sentences for a Hungarian learner to READ "
        "ALOUD as pronunciation practice. EVERY sentence MUST be in English, "
        "never in Hungarian. Make them clear and speakable. Level "
        f"CEFR {level.upper()}: {GUIDE[level]}. Vary the vocabulary and structure; "
        "no numbering, no quotes. Return JSON only: {\"sentences\": [...]}.")
    user = f"Generate {n} different {level.upper()} sentences. Variety batch #{seed}."
    payload = {"model": MODEL, "max_tokens": 2048,
               "messages": [{"role": "system", "content": system},
                            {"role": "user", "content": user}],
               "response_format": {"type": "json_schema",
                   "json_schema": {"name": "s", "strict": True, "schema": SCHEMA}}}
    req = urllib.request.Request(URL, data=json.dumps(payload).encode(),
        headers={"Authorization": f"Bearer {k}", "content-type": "application/json"})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=120) as r:
                content = json.loads(r.read())["choices"][0]["message"]["content"]
            content = re.sub(r"^```[a-z]*\s*|\s*```$", "", content.strip())
            return json.loads(content)["sentences"]
        except Exception as e:  # noqa: BLE001
            if attempt == 2:
                print("  batch failed:", e)
                return []


_HU_CHARS = re.compile(r'[áéíóöőúüűÁÉÍÓÖŐÚÜŰ]')


def clean(s):
    s = s.strip().strip('"').strip()
    if _HU_CHARS.search(s):
        return None  # reject Hungarian sentences that occasionally slip in
    return s if 1 <= len(s.split()) <= 16 and s[-1:] in ".?!" else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--per-level", type=int, default=167)
    args = ap.parse_args()
    k = key()

    out = []
    for level in ("a1", "a2", "b1"):
        target = args.per_level
        n_batches = (target // CHUNK) + 2
        seen = set()
        with ThreadPoolExecutor(max_workers=6) as ex:
            futures = [ex.submit(call, k, level, CHUNK, i) for i in range(n_batches)]
            for f in futures:
                for s in f.result():
                    c = clean(s)
                    if c and c.lower() not in seen:
                        seen.add(c.lower())
                        out.append({"level": level, "text": c})
        got = sum(1 for w in out if w["level"] == level)
        print(f"  {level}: {got} sentences")

    OUT.write_text(json.dumps(out, ensure_ascii=False, indent=2))
    print(f"Wrote {len(out)} sentences to {OUT}")


if __name__ == "__main__":
    main()
