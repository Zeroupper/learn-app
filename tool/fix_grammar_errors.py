#!/usr/bin/env python3
"""One-off: fix semantically wrong grammar exercises found in manual review.

Matches each exercise by its current prompt_hu and overwrites the given fields.
No API calls. Run once: python tool/fix_grammar_errors.py
"""
import json
from pathlib import Path

G = Path("assets/data/grammar")

# file -> list of (match_prompt, patch_dict)
FIXES = {
    "01_articles.json": [
        ("There is ___ university near my house.",
         {"correct_index": 0,
          "explanation_hu": "Az 'u' itt 'yu' (mássalhangzó-) hanggal kezdődik, ezért 'a university'."}),
        ("Can you pass me ___ salt?",
         {"correct_index": 2,
          "explanation_hu": "Konkrét, jelen lévő dologra utalunk (add ide a sót), ezért 'the'."}),
        ("This is ___ nice garden.",
         {"correct_index": 0,
          "explanation_hu": "A 'nice' mássalhangzó-hanggal kezdődik, ezért 'a'."}),
        ("He gave me ___ advice about my job.",
         {"prompt_hu": "He gave me ___ idea for my project.", "correct_index": 1,
          "explanation_hu": "Az 'idea' magánhangzó-hanggal kezdődik, ezért 'an'."}),
        ("I enjoy eating ___ ice cream in summer.",
         {"prompt_hu": "I bought ___ ice cream at the shop.", "correct_index": 1,
          "explanation_hu": "Az 'ice' magánhangzó-hanggal kezdődik, ezért 'an'."}),
        ("I like ___ flowers in spring.",
         {"prompt_hu": "I like ___ flower from the garden.", "correct_index": 0,
          "explanation_hu": "Egyes számú, mássalhangzó-hanggal kezdődő főnév előtt 'a'."}),
        ("She drinks ___ coffee every morning.",
         {"options": ["a", "the", "–"]}),
        ("They are looking for ___ house in the city.",
         {"options": ["a", "the", "–"]}),
        ("I need ___ help with this project.",
         {"options": ["a", "the", "–"]}),
        ("I have ___ information about the meeting.",
         {"options": ["a", "the", "–"], "correct_index": 2,
          "explanation_hu": "Az 'information' megszámlálhatatlan főnév, ezért általában nincs névelő."}),
        ("She likes to eat ___ vegetables.",
         {"options": ["a", "the", "–"]}),
        ("I bought ___ bread and ___ milk at the store.",
         {"prompt_hu": "I bought ___ apple and ___ orange at the store.",
          "options": ["a / a", "an / an", "the / the"], "correct_index": 1,
          "explanation_hu": "Mindkét főnév magánhangzó-hanggal kezdődik, ezért 'an'."}),
    ],
    "02_to_be.json": [
        ("___ is my name Peter?",
         {"prompt_hu": "___ my name Peter?", "correct_index": 0,
          "explanation_hu": "Egyes szám 3. személyű alany ('my name'), ezért 'Is'."}),
        ("I'm ___",
         {"prompt_hu": "She and I ___ good friends.", "options": ["is", "am", "are"],
          "correct_index": 2,
          "explanation_hu": "Az alany többes számú ('She and I' = we), ezért 'are'."}),
        ("He isn't ___ pianist.",
         {"correct_index": 0,
          "explanation_hu": "A 'pianist' mássalhangzó-hanggal kezdődik, ezért 'a'."}),
        ("I'm not ___ doctor.",
         {"correct_index": 0,
          "explanation_hu": "A 'doctor' mássalhangzó-hanggal kezdődik, ezért 'a'."}),
        ("I am ___ student.",
         {"correct_index": 2,
          "explanation_hu": "A 'student' mássalhangzó-hanggal kezdődik, ezért 'a'."}),
    ],
    "05_word_order.json": [
        ("They ___ their bags in the hotel room right now.",
         {"prompt_hu": "They ___ their bags in the hotel room every morning.",
          "correct_index": 0,
          "explanation_hu": "Többes számú alany ('they') egyszerű jelenben alapalakot kap: 'pack'."}),
    ],
    "08_prepositions.json": [
        ("The lamp stands ___ the corner of the room.",
         {"correct_index": 2,
          "explanation_hu": "Szoba sarkában (zárt tér belseje) 'in the corner'."}),
        ("The keys are ___ the table ___ the entrance.",
         {"prompt_hu": "The keys are ___ the table.", "options": ["on", "in", "at"],
          "correct_index": 0, "explanation_hu": "Felületen lévő tárgy 'on'."}),
        ("The flowers are ___ the vase ___ the table.",
         {"prompt_hu": "The flowers are ___ the vase.", "options": ["in", "on", "at"],
          "correct_index": 0, "explanation_hu": "Edény belsejében lévő tárgy 'in'."}),
        ("She arrived ___ the office ___ 9 a.m.",
         {"prompt_hu": "She arrived at the office ___ 9 a.m.",
          "options": ["at", "in", "on"], "correct_index": 0,
          "explanation_hu": "Pontos óra előtt 'at'."}),
    ],
    "12_comparatives.json": [
        ("He is the ___ student in the school.",
         {"options": ["more clever", "cleverest", "cleverer"]}),
        ("That is the ___ idea I have ever heard.",
         {"options": ["more stupid", "stupidest", "stupider"]}),
    ],
}


def main():
    total = 0
    for fname, fixes in FIXES.items():
        path = G / fname
        lesson = json.loads(path.read_text())
        by_prompt = {e["prompt_hu"]: e for e in lesson["exercises"]}
        for match, patch in fixes:
            if match not in by_prompt:
                raise SystemExit(f"NOT FOUND in {fname}: {match!r}")
            by_prompt[match].update(patch)
            total += 1
        path.write_text(json.dumps(lesson, ensure_ascii=False, indent=2))
        print(f"  {fname}: {len(fixes)} fixed")
    print(f"total fixed: {total}")


if __name__ == "__main__":
    main()
