import 'dart:math' as math;

import 'package:flame/components.dart';

import '../../domain/gait_detector.dart';
import '../asset_manifest.dart';
import '../park_path.dart';

/// The runner: standing, walking and running animations in two isometric
/// facings (the other two are mirrored). It glides toward the target
/// distance at a smooth speed, so bursty step events don't make it jump.
class Runner extends SpriteAnimationGroupComponent<String>
    with HasGameReference {
  Runner({required this.path, required double startPixels})
    : displayedPixels = startPixels,
      targetPixels = startPixels,
      super(anchor: Anchor.bottomCenter, priority: _characterPriority);

  static const int _characterPriority = 1000000;

  /// The runner covers a gap within about this long...
  static const double catchUpSeconds = 1.5;

  /// ...but never slower than this, so the last pixels don't crawl.
  static const double minGlideSpeed = 20;

  final ParkPath path;

  /// Where the runner is drawn now, in path pixels.
  double displayedPixels;

  /// Where the step count says the runner should be, in path pixels.
  double targetPixels;

  Gait gait = Gait.standing;

  bool _facingUp = false;

  @override
  Future<void> onLoad() async {
    Future<Map<String, SpriteAnimation>> sheet(
      String name,
      SheetSpec spec,
    ) async {
      final image = await game.images.load(spec.file);
      SpriteAnimation row(int r) => SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: spec.frames,
          stepTime: spec.stepTime,
          textureSize: Vector2(spec.frameWidth, spec.frameHeight),
          texturePosition: Vector2(0, r * spec.frameHeight),
          loop: spec.loop,
        ),
      );
      return {'${name}_down': row(0), '${name}_up': row(1)};
    }

    animations = {
      ...await sheet(Gait.standing.name, AssetManifest.runnerIdle),
      ...await sheet(Gait.walking.name, AssetManifest.runnerWalk),
      ...await sheet(Gait.running.name, AssetManifest.runnerRun),
    };
    size = Vector2(
      AssetManifest.runnerWalk.frameWidth,
      AssetManifest.runnerWalk.frameHeight,
    );
    _place();
  }

  @override
  void update(double dt) {
    final gap = targetPixels - displayedPixels;
    if (gap > 0) {
      final step = math.max(gap * dt / catchUpSeconds, minGlideSpeed * dt);
      displayedPixels += math.min(gap, step);
    }
    _place();
    super.update(dt);
  }

  void _place() {
    final p = path.positionAt(displayedPixels);
    position.setValues(p.dx, p.dy);

    final dir = path.directionAt(displayedPixels);
    if (dir.dy.abs() > 0.05) _facingUp = dir.dy < 0;
    final mirrored = dir.dx < 0;
    scale.x = mirrored ? -1 : 1;

    // Still catching up with the last steps: keep the legs moving.
    final stillGliding = targetPixels - displayedPixels > 1;
    final shown = gait == Gait.standing && stillGliding ? Gait.walking : gait;
    current = '${shown.name}_${_facingUp ? 'up' : 'down'}';
  }
}
