import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/celebration_music.dart';

void main() {
  test('every track points somewhere in assets/audio and starts mid-song', () {
    for (final t in celebrationTracks) {
      expect(t.asset, startsWith('audio/'),
          reason: 'AssetSource paths are relative to assets/');
      expect(t.start, greaterThan(Duration.zero),
          reason: '${t.asset} should skip its intro');
    }
    expect(celebrationFallback, startsWith('audio/'));
    expect(celebrationCheer, startsWith('audio/'));
  });

  test('the fade-in is long enough to sit under the cheer', () {
    expect(celebrationFadeIn, const Duration(seconds: 4));
  });

  test('no duplicate files in the list', () {
    final assets = celebrationTracks.map((t) => t.asset).toList();
    expect(assets.toSet().length, assets.length);
  });

  test('picking always returns a track from the list', () {
    for (var seed = 0; seed < 50; seed++) {
      expect(celebrationTracks, contains(pickCelebrationTrack(Random(seed))));
    }
  });

  test('the same seed picks the same track, different seeds spread out', () {
    expect(pickCelebrationTrack(Random(7)).asset,
        pickCelebrationTrack(Random(7)).asset);

    // Over many draws every track should come up — a pick stuck on one entry
    // would make the celebration feel identical every day.
    final seen = {
      for (var seed = 0; seed < 200; seed++)
        pickCelebrationTrack(Random(seed)).asset,
    };
    expect(seen.length, celebrationTracks.length);
  });
}
