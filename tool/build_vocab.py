#!/usr/bin/env python3
"""Build assets/data/vocabulary.json fully offline (no API key).

Word selection + CEFR levels come from the CEFR-J Wordlist (CC BY-SA 4.0).
Hungarian translations come from a Hungarian->English Wiktionary .mobi
dictionary, inverted and frequency-reranked (Wiktionary data is CC BY-SA 4.0).

Inputs:
  tool/cefrj-wordlist.csv   (headword,pos,CEFR,...)
  a HU->EN Wiktionary .mobi  (default: ~/Downloads/Hungarian-English Wiktionary dictionary.mobi)

Requirements (build-time only, not shipped):
  pip install mobi beautifulsoup4 wordfreq

Usage:
  python tool/build_vocab.py [--mobi PATH] [--a1 600 --a2 700 --b1 700]

Quality: ~85-90% of translations are correct/acceptable; verbs come out as the
standard 3rd-person-singular lemma (e.g. "tanul", "ad"). Spot-check the output.
"""
import argparse
import csv
import json
import os
import re
from collections import defaultdict
from pathlib import Path

import mobi
from wordfreq import zipf_frequency

CSV = Path("tool/cefrj-wordlist.csv")
OVERRIDES = Path("tool/overrides.json")
OUT = Path("assets/data/vocabulary.json")
DEFAULT_MOBI = os.path.expanduser(
    "~/Downloads/Hungarian-English Wiktionary dictionary.mobi")
KEEP_POS = {"noun", "verb", "adjective", "adverb"}
POSMAP = {"noun": "noun", "verb": "verb", "adjective": "adjective",
          "adverb": "adverb", "numeral": "noun"}

_entry_re = re.compile(r'<idx:orth value="([^"]+)"')
_pos_re = re.compile(r"<i>([^<]+)</i>")
_li_re = re.compile(r'<li value="\d+">(.*?)</li>', re.S)
_tag_re = re.compile(r"<[^>]+>")
_word_re = re.compile(r"^[a-z][a-z\- ]*$")


def clean_gloss(g: str) -> str:
    g = _tag_re.sub("", g)
    g = re.sub(r"\([^)]*\)", "", g)          # drop "(physics)", "(rare)" ...
    g = g.split(";")[0].split(",")[0].strip().lower()
    if g.startswith("to "):                   # verb glosses: "to eat" -> "eat"
        g = g[3:]
    return g.strip()


def build_inversion(mobi_path: str):
    """english term -> list of (hu_headword, pos, sense_index)."""
    tmpdir, _ = mobi.extract(mobi_path)
    book = None
    for root, _dirs, files in os.walk(tmpdir):
        if "book.html" in files:
            book = os.path.join(root, "book.html")
            break
    if not book:
        raise SystemExit("Could not find book.html inside the .mobi")
    data = open(book, encoding="utf-8", errors="replace").read()

    en2hu = defaultdict(list)
    for e in data.split("<idx:entry")[1:]:
        m = _entry_re.search(e)
        if not m:
            continue
        hu = m.group(1)
        pm = _pos_re.search(e)
        pos = pm.group(1).strip().lower() if pm else ""
        for gi, g in enumerate(_li_re.findall(e)):
            t = clean_gloss(g)
            if t and len(t) <= 25 and t.count(" ") <= 1 and _word_re.match(t):
                en2hu[t].append((hu, pos, gi))
    return en2hu


# Vulgar/slang glosses Wiktionary lists that we never want to surface as answers.
BLOCK = {"szar", "fasz", "geci", "picsa", "kurva", "baszik", "lóvé", "mani",
         "tütü", "meló", "suli", "bari", "haver"}


def translate(en2hu, en: str, pos: str):
    """Return the primary Hungarian translation, plus a near-frequency second
    (only when it's an equally common synonym, not long-tail noise)."""
    cands = en2hu.get(en.lower(), [])
    if not cands:
        return []
    want = POSMAP.get(pos, "")
    best = {}
    for hu, p, gi in cands:
        if hu in BLOCK:
            continue
        # rank: matching POS first, earliest sense, then most common Hungarian
        score = -(want == p) * 2 + gi * 0.5 - zipf_frequency(hu, "hu")
        if hu not in best or score < best[hu]:
            best[hu] = score
    if not best:
        return []
    ranked = [w for w, _ in sorted(best.items(), key=lambda kv: kv[1])]
    top = ranked[0]
    result = [top]
    top_freq = zipf_frequency(top, "hu")
    for w in ranked[1:]:
        # keep a second only if it's an near-equally-common synonym
        if zipf_frequency(w, "hu") >= top_freq - 0.6:
            result.append(w)
            break
    return result


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--mobi", default=DEFAULT_MOBI)
    ap.add_argument("--a1", type=int, default=600)
    ap.add_argument("--a2", type=int, default=700)
    ap.add_argument("--b1", type=int, default=700)
    args = ap.parse_args()
    targets = {"a1": args.a1, "a2": args.a2, "b1": args.b1}

    print("Inverting dictionary...")
    en2hu = build_inversion(args.mobi)
    print(f"  {len(en2hu)} English terms indexed")

    overrides = {k: v for k, v in json.loads(OVERRIDES.read_text()).items()
                 if not k.startswith("_")}
    print(f"  {len(overrides)} hand-verified overrides")

    # Collect CEFR-J candidates per level, frequency-ranked.
    buckets = defaultdict(list)
    with CSV.open(encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            level = (row.get("CEFR") or "").strip().lower()
            pos = (row.get("pos") or "").strip().lower()
            hw = (row.get("headword") or "").strip().lower()
            if level not in targets or pos not in KEEP_POS:
                continue
            if not _word_re.match(hw) or " " in hw:
                continue
            buckets[level].append((hw, pos))
    for level in buckets:
        buckets[level].sort(key=lambda wp: -zipf_frequency(wp[0], "en"))

    out = []
    next_id = 1
    for level in ("a1", "a2", "b1"):
        kept = 0
        seen = set()
        for hw, pos in buckets[level]:
            if kept >= targets[level]:
                break
            if hw in seen:
                continue
            seen.add(hw)
            hu = overrides.get(hw) or translate(en2hu, hw, pos)
            if not hu:                      # skip words we can't translate
                continue
            out.append({
                "id": next_id, "en": hw, "en_accepted": [], "hu": hu,
                "level": level, "pos": pos, "example_en": None, "example_hu": None,
            })
            next_id += 1
            kept += 1
        print(f"  {level}: {kept} words (target {targets[level]})")

    assert len({w["id"] for w in out}) == len(out)
    assert all(w["hu"] for w in out)
    OUT.write_text(json.dumps(out, ensure_ascii=False, indent=2))
    print(f"Wrote {len(out)} words to {OUT}. Spot-check before shipping.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
