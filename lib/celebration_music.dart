import 'dart:math';

/// One celebration track and the point to drop the needle at — these all open
/// with an intro, and the screen is only up for a few seconds, so playback
/// jumps straight to the part worth hearing.
class CelebrationTrack {
  const CelebrationTrack(this.asset, this.start);

  /// Path under `assets/`, which is what [AssetSource] expects.
  final String asset;

  final Duration start;
}

/// Add a track by dropping the file in `assets/audio/` and adding a line here.
/// Anything missing at runtime falls back to the drum roll, so a half-filled
/// list is safe.
const celebrationTracks = <CelebrationTrack>[
  CelebrationTrack(
    'audio/sweet_child_o_mine.mp3',
    Duration(minutes: 1, seconds: 19),
  ),
  CelebrationTrack('audio/itt_es_most.mp3', Duration(minutes: 1, seconds: 12)),
  CelebrationTrack(
    'audio/come_as_you_are.mp3',
    Duration(minutes: 1, seconds: 6),
  ),
  CelebrationTrack(
    'audio/hol_van_a_szo.mp3',
    Duration(minutes: 1, seconds: 58),
  ),
  CelebrationTrack(
    'audio/itelet_helyett.mp3',
    Duration(minutes: 1, seconds: 32),
  ),
  CelebrationTrack('audio/every_breath_you_take.mp3', Duration(seconds: 48)),
];

/// Played when the picked track is missing — the app still makes a noise
/// before any music has been added.
const celebrationFallback = 'audio/success_drum_roll.mp3';

/// Applause, at full volume from the first frame, while the music fades up
/// underneath it.
const celebrationCheer = 'audio/crowd_cheer.mp3';

/// How long the music takes to reach full volume.
const celebrationFadeIn = Duration(seconds: 4);

/// The cheer swells in a little quicker than the music behind it.
const celebrationCheerFadeIn = Duration(seconds: 3);

final _random = Random();

/// A random track for this celebration. Pass [random] to make it repeatable.
CelebrationTrack pickCelebrationTrack([Random? random]) =>
    celebrationTracks[(random ?? _random).nextInt(celebrationTracks.length)];
