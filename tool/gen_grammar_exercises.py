#!/usr/bin/env python3
"""Expand each grammar lesson to ~50 self-check exercises via OpenRouter.

Keeps existing exercises, generates the rest from the lesson content, in the
same JSON shape. Reads the key from .env.

Usage: python tool/gen_grammar_exercises.py [--target 50]
"""
import argparse
import json
import re
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

GRAMMAR = Path("assets/data/grammar")
ENV = Path(".env")
URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL = "anthropic/claude-haiku-4.5"

SCHEMA = {
    "type": "object", "additionalProperties": False, "required": ["exercises"],
    "properties": {"exercises": {"type": "array", "items": {
        "type": "object", "additionalProperties": False,
        "required": ["prompt_hu", "options", "correct_index", "explanation_hu"],
        "properties": {
            "prompt_hu": {"type": "string"},
            "options": {"type": "array", "items": {"type": "string"}},
            "correct_index": {"type": "integer"},
            "explanation_hu": {"type": "string"},
        }}}},
}


def key():
    for line in ENV.read_text().splitlines():
        if line.startswith("OPENROUTER_API_KEY="):
            return line.split("=", 1)[1].strip()
    raise SystemExit("OPENROUTER_API_KEY not found in .env")


def call(k, system, user, max_tokens):
    p = {"model": MODEL, "max_tokens": max_tokens,
         "messages": [{"role": "system", "content": system},
                      {"role": "user", "content": user}],
         "response_format": {"type": "json_schema",
                             "json_schema": {"name": "ex", "strict": True, "schema": SCHEMA}}}
    req = urllib.request.Request(URL, data=json.dumps(p).encode(),
        headers={"Authorization": f"Bearer {k}", "content-type": "application/json"})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=180) as r:
                content = json.loads(r.read())["choices"][0]["message"]["content"]
            content = re.sub(r"^```[a-z]*\s*|\s*```$", "", content.strip())
            return json.loads(content)["exercises"]
        except Exception as e:  # noqa: BLE001
            if attempt == 2:
                print("   call failed:", e)
                return []


# Hungarian-reject gate: the fill-in sentence and the options are ENGLISH ONLY.
# This is the hard guarantee — the prompt asks for it, this enforces it.
_HU_CHARS = set("áéíóöőúüűÁÉÍÓÖŐÚÜŰ")
_HU_WORDS = re.compile(
    r"\b(egy|az|ez|nem|van|nincs|vagy|hogy|meg|mert|kell|itt|ott|és|volt|lesz|"
    r"melyik|helyes|egészítsd|töltsd|válaszd|hiányzó|szó|mondat|fordítsd)\b", re.I)


def _is_hungarian(s):
    return bool(set(s) & _HU_CHARS) or bool(_HU_WORDS.search(s or ""))


def valid(ex):
    if not (isinstance(ex.get("options"), list) and 2 <= len(ex["options"]) <= 4
            and isinstance(ex.get("correct_index"), int)
            and 0 <= ex["correct_index"] < len(ex["options"])
            and ex.get("prompt_hu") and ex.get("explanation_hu")):
        return False
    p = ex["prompt_hu"]
    if "___" not in p:
        return False  # must be a fill-in-the-blank
    if _is_hungarian(p) or any(_is_hungarian(o) for o in ex["options"]):
        return False  # sentence/options leaked Hungarian → drop it
    if any(o.strip().endswith((".", "?", "!")) for o in ex["options"]):
        return False  # options must be words/forms, not whole sentences
    return True


SYSTEM = (
    "You write multiple-choice fill-in-the-blank exercises that teach ENGLISH to "
    "Hungarian speakers. The learner reads an English sentence with one word "
    "missing and picks the correct English word.\n\n"
    "STRICT RULES:\n"
    "- 'prompt_hu' is ONE English sentence containing exactly one blank written "
    "as ___ . It is ENGLISH ONLY: no Hungarian, no instruction text, no "
    "parenthetical translation. This is a fill-in-the-blank, NOT a translation.\n"
    "- 'options' are 2-4 English words or short verb/article/pronoun forms that "
    "fit the blank. Never whole sentences. Exactly ONE is grammatically correct.\n"
    "- 'correct_index' is the 0-based index of the correct option.\n"
    "- 'explanation_hu' is ONE short sentence in Hungarian saying why. This is the "
    "ONLY Hungarian field.\n\n"
    "GOOD:\n"
    '{"prompt_hu":"She is ___ engineer.","options":["a","an","the"],'
    '"correct_index":1,"explanation_hu":"Magánhangzó-hanggal kezdődő szó előtt \'an\'."}\n'
    '{"prompt_hu":"They ___ watching TV right now.","options":["is","are","am"],'
    '"correct_index":1,"explanation_hu":"Többes szám 3. személyben \'are\'."}\n'
    '{"prompt_hu":"This box is ___ than that one.","options":["heavy","heavier",'
    '"heaviest"],"correct_index":1,"explanation_hu":"Két dolog összehasonlításakor középfok."}\n\n'
    "BAD — never produce these:\n"
    "- Hungarian sentence in the prompt: \"Ez egy autó. ___\" (WRONG, prompt must be English).\n"
    "- Options that are whole sentences: [\"This is a car.\",\"This is an car.\"] (WRONG).\n"
    "- Hungarian instruction: \"Egészítsd ki: She is ___ teacher.\" (WRONG, drop the instruction, keep \"She is ___ teacher.\").\n\n"
    "Vary the sentences, cover all the rules, exactly one option correct, do not "
    "repeat existing exercises. Return JSON only.")


def expand(k, meta, target, rebuild):
    path = GRAMMAR / meta["file"]
    lesson = json.loads(path.read_text())
    have = [] if rebuild else lesson["exercises"]
    need = target - len(have)
    if need <= 0:
        return meta["file"], len(have)

    ctx = f"Lesson: {lesson['title_hu']} (CEFR {lesson['level'].upper()})\n\nRules:\n"
    for s in lesson["sections"]:
        ctx += f"- {s['heading_hu']}: {s['body_hu']}\n"
    seen = {e["prompt_hu"] for e in have}
    # Keep generating until target, since the Hungarian-reject gate drops some.
    # ponytail: cap at 6 rounds so a bad model can't loop forever.
    for _ in range(6):
        if len(have) >= target:
            break
        existing = "; ".join(e["prompt_hu"] for e in have)
        n = target - len(have)
        user = (f"{ctx}\nExisting exercises (do not repeat): {existing}\n\n"
                f"Generate {n} new, different exercises for this lesson.")
        for e in call(k, SYSTEM, user, 8192):
            if valid(e) and e["prompt_hu"] not in seen and len(have) < target:
                seen.add(e["prompt_hu"])
                have.append(e)

    lesson["exercises"] = have
    path.write_text(json.dumps(lesson, ensure_ascii=False, indent=2))
    return meta["file"], len(have)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--target", type=int, default=50)
    ap.add_argument("--rebuild", action="store_true",
                    help="discard existing exercises and regenerate from scratch")
    args = ap.parse_args()
    k = key()
    index = json.loads((GRAMMAR / "index.json").read_text())
    print(f"Expanding {len(index)} lessons to {args.target} exercises each"
          f"{' (rebuild)' if args.rebuild else ''}...")
    with ThreadPoolExecutor(max_workers=6) as ex:
        for f in [ex.submit(expand, k, m, args.target, args.rebuild) for m in index]:
            file, n = f.result()
            print(f"  {file}: {n} exercises")


if __name__ == "__main__":
    main()
