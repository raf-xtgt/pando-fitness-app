import 'dart:math' as math;

import 'package:flame/components.dart';

import '../asset_manifest.dart';
import '../park_path.dart';
import 'runner.dart';

/// What the mascot is doing. [celebrate] and [firstActivity] play once,
/// then it goes back to [hover].
enum MascotMove { hover, celebrate, firstActivity }

/// The small winged companion. Hovers with a gentle bob and trails the
/// runner by a fixed distance along the path.
class Mascot extends SpriteAnimationGroupComponent<MascotMove>
    with HasGameReference {
  Mascot({required this.path, required this.runner})
    : super(
        anchor: Anchor.bottomCenter,
        priority: 1000001,
        current: MascotMove.hover,
      );

  /// How far behind the runner the mascot flies, in path pixels.
  static const double trailPixels = 110;

  /// How high above the path the mascot hovers.
  static const double hoverHeight = 70;
  static const double bobHeight = 6;
  static const double bobSpeed = 2.4;

  final ParkPath path;
  final Runner runner;

  double _time = 0;

  @override
  Future<void> onLoad() async {
    Future<SpriteAnimation> load(SheetSpec spec) async =>
        SpriteAnimation.fromFrameData(
          await game.images.load(spec.file),
          SpriteAnimationData.sequenced(
            amount: spec.frames,
            stepTime: spec.stepTime,
            textureSize: Vector2(spec.frameWidth, spec.frameHeight),
            loop: spec.loop,
          ),
        );

    animations = {
      MascotMove.hover: await load(AssetManifest.mascotHover),
      MascotMove.celebrate: await load(AssetManifest.mascotCelebrate),
      MascotMove.firstActivity: await load(AssetManifest.mascotFirstActivity),
    };
    const spec = AssetManifest.mascotHover;
    size = Vector2(spec.frameWidth, spec.frameHeight);
    _place();
  }

  /// Plays a one-off move from its first frame, then returns to hover.
  /// Completes when the move has finished.
  Future<void> play(MascotMove move) async {
    current = move;
    if (move == MascotMove.hover) return;
    await animationTicker!.completed;
    if (current == move) current = MascotMove.hover;
  }

  @override
  void update(double dt) {
    _time += dt;
    _place();
    super.update(dt);
  }

  void _place() {
    final along = runner.displayedPixels - trailPixels;
    final p = path.positionAt(along);
    final bob = math.sin(_time * bobSpeed) * bobHeight;
    position.setValues(p.dx, p.dy - hoverHeight + bob);
    // Face the way the runner is heading.
    scale.x = path.directionAt(along).dx < 0 ? -1 : 1;
  }
}
