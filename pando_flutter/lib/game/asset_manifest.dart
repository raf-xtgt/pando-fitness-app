/// Every art file name, frame size and frame count lives here, and nowhere
/// else. Paths are relative to `assets/art/` (the game's image prefix).
///
/// The art itself is licensed and gitignored; see `CREDITS.md`.
library;

/// One horizontal-strip sprite sheet: [rows] rows of [frames] frames each.
class SheetSpec {
  const SheetSpec({
    required this.file,
    required this.frameWidth,
    required this.frameHeight,
    required this.frames,
    required this.fps,
    this.rows = 1,
    this.loop = true,
  });

  final String file;
  final double frameWidth;
  final double frameHeight;
  final int frames;
  final double fps;
  final int rows;
  final bool loop;

  double get stepTime => 1 / fps;
}

abstract final class AssetManifest {
  static const String imagePrefix = 'assets/art/';

  // Park map (Tiled). The map loader wants a folder prefix and a bare name.
  static const String parkFolder = 'assets/art/park/';
  static const String parkMap = 'park.tmx';
  static const String parkTilesetName = 'park_tiles';
  static const String parkObjectsFolder = 'park/';
  static const String objectsLayer = 'objects';
  static const String pathLayer = 'path';
  static const String pathObject = 'path';

  // Runner: 192x192 frames. Row 0 faces down-right, row 1 faces up-right;
  // the left-hand facings are mirrored in code.
  static const SheetSpec runnerIdle = SheetSpec(
    file: 'runner/runner_idle.png',
    frameWidth: 192,
    frameHeight: 192,
    frames: 6,
    fps: 6,
    rows: 2,
  );
  static const SheetSpec runnerWalk = SheetSpec(
    file: 'runner/runner_walk.png',
    frameWidth: 192,
    frameHeight: 192,
    frames: 8,
    fps: 10,
    rows: 2,
  );
  static const SheetSpec runnerRun = SheetSpec(
    file: 'runner/runner_run.png',
    frameWidth: 192,
    frameHeight: 192,
    frames: 8,
    fps: 14,
    rows: 2,
  );

  // Mascot: 96x96 frames, one front-facing row.
  static const SheetSpec mascotHover = SheetSpec(
    file: 'mascot/mascot_hover.png',
    frameWidth: 96,
    frameHeight: 96,
    frames: 8,
    fps: 8,
  );

  // Played once, then back to hover (see mascot/SHEETS.md).
  static const SheetSpec mascotCelebrate = SheetSpec(
    file: 'mascot/mascot_celebrate.png',
    frameWidth: 96,
    frameHeight: 96,
    frames: 12,
    fps: 12,
    loop: false,
  );
  static const SheetSpec mascotFirstActivity = SheetSpec(
    file: 'mascot/mascot_first_activity.png',
    frameWidth: 96,
    frameHeight: 96,
    frames: 20,
    fps: 8,
    loop: false,
  );

  // Wooden sign: a single 51x128 image, base at the bottom centre.
  static const String woodenSign = 'sign/wooden_sign.png';

  // Lettering: made for Pando (not licensed art), so it's committed and
  // lives outside the gitignored art folder. Full asset paths.
  static const String wordmark = 'assets/lettering/pando_wordmark.svg';

  /// One fire glyph per character of `+123 m`: digits, `m` and `plus`.
  static String fireGlyph(String char) =>
      'assets/lettering/fire_${char == '+' ? 'plus' : char}.svg';
}
